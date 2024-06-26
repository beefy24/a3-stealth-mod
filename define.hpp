//Enables debug mode.
#define DEBUG_MODE_ON

//Enables target loss timer.
#define TARGET_LOSS_ON

//Enables camouflage adjustments.
#define CAMOUFLAGE_ON

//Macros
#ifdef DEBUG_MODE_ON
#define DEBUG_AND(variable) && variable
#define DEBUG_OR(variable) || variable
#else
#define DEBUG_AND(variable)
#define DEBUG_OR(variable)
#endif