/*
 * Model_data.c
 *
 * Code generation for model "Model".
 *
 * Model version              : 1.0
 * Simulink Coder version : 8.9 (R2015b) 13-Aug-2015
 * C source code generated on : Tue May 30 17:12:49 2017
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "Model.h"
#include "Model_private.h"

/* Block parameters (auto storage) */
P_Model_T Model_P = {
  20.0,                                /* Variable: Kp
                                        * Referenced by: '<Root>/Kp'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<Root>/Integrator'
                                        */
  0.6,                                 /* Expression: 0.6
                                        * Referenced by: '<Root>/Signal Generator'
                                        */
  5.0E-6,                              /* Expression: 5E-6
                                        * Referenced by: '<Root>/Signal Generator'
                                        */
  -23.209620771542717,                 /* Computed Parameter: TransferFcn_A
                                        * Referenced by: '<Root>/Transfer Fcn'
                                        */
  12.722424049956967                   /* Computed Parameter: TransferFcn_C
                                        * Referenced by: '<Root>/Transfer Fcn'
                                        */
};
