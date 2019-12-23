#include <DueTimer.h>

//Pines de lectura del encoder
#define encoderA 7
#define encoderB 3

//PWM duty cycle: 42MHz(clk)/20KHz = 2100
#define duty 2100 

//Pines PWM
#define pwm_2 39
#define pwm_3 41

//Voltaje máximo 
#define maxV 12

//Numero de muestras
#define muestras 1500

// Valores del encoders
volatile int valorA = 0;
volatile int valorB = 0;
volatile int state = 0;
volatile int pre_state = 0;

//Variable de giro del motor
volatile int giro = 0;
volatile double giro_rad = 0;

//Variable contador para capturar los datos
volatile int cont = 0;

//Variable P número de experimentos
int P = 0;

//Array de datos
volatile double datos[muestras];

//Voltaje (No poner más de 12V ni menos de -12V)
double voltaje = 12;

//Parametros del controlador P
const double ref = PI*2; //giro que deseamos que realize el motor
double posFinal = 0; //ref pasado a pulsos del encoder
const double kp = 29.341;
double b[12];

/********************************************************
 ********************   Funciones   *********************
 ********************************************************
 */


/* Esta funcion es la rutina que atienede a la interrpción de los pasos
 * del encoder. Entra en ambos flancos (subida y bajada) y compara los 
 * valores del encoder con los que tenía en la última ejecución. 
 * Dependiendo del cambio realizado le suma o resta 1 a la variable giro
 */
void encoder() {
  valorA = digitalRead(encoderA);
  valorB = digitalRead(encoderB);

  if (valorA == 0 && valorB == 0) {
    state = 0;
  } else if (valorA == 0 && valorB == 1) {
    state = 1;
  } else if (valorA == 1 && valorB == 0) {
    state = 2;
  } else if (valorA == 1 && valorB == 1) {
    state = 3;
  }

  if (state == 0) {
    if (pre_state == 1) {
      giro++;
    } else if (pre_state == 2) {
      giro--;
    }
  } else if (state == 1) {
    if (pre_state == 0) {
      giro--;
    } else if (pre_state == 3) {
      giro++;
    }
  } else if (state == 2) {
    if (pre_state == 0) {
      giro++;
    } else if (pre_state == 3) {
      giro--;
    }
  } else if (state == 3) {
    if (pre_state == 1) {
      giro--;
    } else if (pre_state == 2) {
      giro++;
    }
  }
  pre_state = state;
  giro_rad = to_rad(giro);
}


/* Esta función imprime los datos recogidos en el array
 * de datos a través del puerto serie 
 */
void printDatos(){
  for(int i=0; i < muestras; i++){
    Serial.print(i);
    Serial.print(" ");
    Serial.println(datos[i],6);
  }
}


/* Esta función convierte los datos de radianes
 * a pasos del encoder 
 */
double to_giro(double rad){
  int giro=0;
  giro = (3591.84*rad)/(2*PI);
  return giro;
}


/* Esta función convierte los datos de
 * pasos del encoder a radianes
 */
double to_rad(int giro){
  double rad=0.0;
  rad = (2*PI*giro)/3591.84;
  return rad;
}


/* Esta función establece el ciclo de trabajo
 * de la señal PWM que se introduce al motor
 * en función del voltaje deseado
 */
void setPWMvolt(double volt){
  if(volt > 0){
    PWMC_SetDutyCycle(PWM, 2, (volt/maxV)*duty);
    PWMC_SetDutyCycle(PWM, 3, 0);
  }else if(volt < 0){
    PWMC_SetDutyCycle(PWM, 2, 0);
    PWMC_SetDutyCycle(PWM, 3, -(volt/maxV)*duty);
  }else{
    PWMC_SetDutyCycle(PWM, 2, 0);
    PWMC_SetDutyCycle(PWM, 3, 0);
  }
}


/* Esta función es el controlador tipo P del motor
 * Introduce un voltaje al motor en función del error,
 * definido como la diferencia entre los radianes de
 * referencia (a donde se desea llegar) y los radianes
 * actuales de la posición del motor
 */
void controladorP(){
  //Coger datos giro motor
  datos[cont] = giro_rad; 
  cont++;
  
  double error = 0;
  double u = 0;  
  
  error = ref - giro_rad;
  u = error*kp;

    //Compensación de las no linealidades del motor
    /*for(int j=0; j<12; j++){
      vj+=b[j]*pow(u,((2*j)+1));
    }*/
  
    if(u > 12){
      setPWMvolt(12);
    }else if( u < -12){
      setPWMvolt(-12);
    }else{
      setPWMvolt(u);
    }
    
}


/* Esta función configura el módulo PWM hardware
 * para los pines deseados 
 */
void pwm_frec(uint32_t pin) {
  PIO_Configure(g_APinDescription[pin].pPort,
                //g_APinDescription[pin].ulPinType,
                PIO_PERIPH_B,
                g_APinDescription[pin].ulPin,
                g_APinDescription[pin].ulPinConfiguration);
}


/* Esta función es la prueba del motor para un pulso
 * Con ella modelamos el comportamiento del motor experimentalmente
 */
void pulso_motor(){
  if ( cont < 1199 ){
    if(P>0){
      datos[cont] += giro; 
    }
    if(cont<599){
      setPWMvolt(voltaje);
    } else{
      setPWMvolt(0);
    }
  }
  cont++;
}

void setup() {
  Serial.begin(9600);
  
  // Configuramos los pines del encoder como entradas
  pinMode(encoderA, INPUT);
  pinMode(encoderB, INPUT);

  //Leemos los datos del encoder
  valorA = digitalRead(encoderA);
  valorB = digitalRead(encoderB);
  
  // Configuramos los pines que utilizaremos para señal pwm de ~20KHz
  pinMode(pwm_2, OUTPUT);
  pinMode(pwm_3, OUTPUT);
  pmc_enable_periph_clk(PWM_INTERFACE_ID);
  pwm_frec(pwm_2);
  pwm_frec(pwm_3);
  // Channel 0
  PWMC_ConfigureChannel (PWM, 2, 1, 0, 0);
  PWMC_SetPeriod(PWM, 2, duty);
  PWMC_SetDutyCycle(PWM, 2, 0);
  PWMC_EnableChannel(PWM, 2);
  // Channel 1
  PWMC_ConfigureChannel (PWM, 3, 1, 0, 0);
  PWMC_SetPeriod(PWM, 3, duty);
  PWMC_SetDutyCycle(PWM, 3, 0);
  PWMC_EnableChannel(PWM, 3);

  // Leemos la posición inicial del encoder
  valorA = digitalRead(encoderA);
  valorB = digitalRead(encoderB);

  // Interrupciones cuando cambia el valor del encoder
  attachInterrupt(digitalPinToInterrupt(encoderA), encoder, CHANGE);
  attachInterrupt(digitalPinToInterrupt(encoderB), encoder, CHANGE);

  //Parámetros b
  b[0] =1.16265865042185322496; 
  b[1] =-0.05663810829741048832;
  b[2] =0.01030250890727758976;
  b[3] =-0.00103468614470349040;
  b[4] =0.00006197445357513123;
  b[5] =-0.0000023334023749811975;
  b[6] =0.00000005687489640916592773; 
  b[7] =-0.00000000090593408143452957; 
  b[8] =0.00000000000932058253413296; 
  b[9] =-0.00000000000005943224282751; 
  b[10] =0.00000000000000021277515654; 
  b[11] =-0.00000000000000000032588243; 
  
  // Timers
  Timer1.attachInterrupt(controladorP);
  Timer1.start(1000);

}

void loop() {

  //Experimentos de modelado
  /*while(P<11){
    if(cont>=1199){
      Timer1.stop();
      P++;
      cont = 0;
      giro = 0;
      Timer1.start(1000);
    }
  }*/

  //Controlador P
  if(cont >= muestras){
      Timer1.stop();
      printDatos();
      while(1);
  }
}
