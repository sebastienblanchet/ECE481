/*
 * Model.c
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

/* Block signals (auto storage) */
B_Model_T Model_B;

/* Continuous states */
X_Model_T Model_X;

/* Block states (auto storage) */
DW_Model_T Model_DW;

/* Real-time model */
RT_MODEL_Model_T Model_M_;
RT_MODEL_Model_T *const Model_M = &Model_M_;

/*
 * This function updates continuous states using the ODE3 fixed-step
 * solver algorithm
 */
static void rt_ertODEUpdateContinuousStates(RTWSolverInfo *si )
{
  /* Solver Matrices */
  static const real_T rt_ODE3_A[3] = {
    1.0/2.0, 3.0/4.0, 1.0
  };

  static const real_T rt_ODE3_B[3][3] = {
    { 1.0/2.0, 0.0, 0.0 },

    { 0.0, 3.0/4.0, 0.0 },

    { 2.0/9.0, 1.0/3.0, 4.0/9.0 }
  };

  time_T t = rtsiGetT(si);
  time_T tnew = rtsiGetSolverStopTime(si);
  time_T h = rtsiGetStepSize(si);
  real_T *x = rtsiGetContStates(si);
  ODE3_IntgData *id = (ODE3_IntgData *)rtsiGetSolverData(si);
  real_T *y = id->y;
  real_T *f0 = id->f[0];
  real_T *f1 = id->f[1];
  real_T *f2 = id->f[2];
  real_T hB[3];
  int_T i;
  int_T nXc = 2;
  rtsiSetSimTimeStep(si,MINOR_TIME_STEP);

  /* Save the state values at time t in y, we'll use x as ynew. */
  (void) memcpy(y, x,
                (uint_T)nXc*sizeof(real_T));

  /* Assumes that rtsiSetT and ModelOutputs are up-to-date */
  /* f0 = f(t,y) */
  rtsiSetdX(si, f0);
  Model_derivatives();

  /* f(:,2) = feval(odefile, t + hA(1), y + f*hB(:,1), args(:)(*)); */
  hB[0] = h * rt_ODE3_B[0][0];
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[0]);
  rtsiSetdX(si, f1);
  Model_step();
  Model_derivatives();

  /* f(:,3) = feval(odefile, t + hA(2), y + f*hB(:,2), args(:)(*)); */
  for (i = 0; i <= 1; i++) {
    hB[i] = h * rt_ODE3_B[1][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[1]);
  rtsiSetdX(si, f2);
  Model_step();
  Model_derivatives();

  /* tnew = t + hA(3);
     ynew = y + f*hB(:,3); */
  for (i = 0; i <= 2; i++) {
    hB[i] = h * rt_ODE3_B[2][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1] + f2[i]*hB[2]);
  }

  rtsiSetT(si, tnew);
  rtsiSetSimTimeStep(si,MAJOR_TIME_STEP);
}

/* Model step function */
void Model_step(void)
{
  real_T temp;
  if (rtmIsMajorTimeStep(Model_M)) {
    /* set solver stop time */
    if (!(Model_M->Timing.clockTick0+1)) {
      rtsiSetSolverStopTime(&Model_M->solverInfo, ((Model_M->Timing.clockTickH0
        + 1) * Model_M->Timing.stepSize0 * 4294967296.0));
    } else {
      rtsiSetSolverStopTime(&Model_M->solverInfo, ((Model_M->Timing.clockTick0 +
        1) * Model_M->Timing.stepSize0 + Model_M->Timing.clockTickH0 *
        Model_M->Timing.stepSize0 * 4294967296.0));
    }
  }                                    /* end MajorTimeStep */

  /* Update absolute time of base rate at minor time step */
  if (rtmIsMinorTimeStep(Model_M)) {
    Model_M->Timing.t[0] = rtsiGetT(&Model_M->solverInfo);
  }

  /* Integrator: '<Root>/Integrator' */
  Model_B.Integrator = Model_X.Integrator_CSTATE;
  if (rtmIsMajorTimeStep(Model_M)) {
    /* Scope: '<Root>/Theta Gear' */
    if (rtmIsMajorTimeStep(Model_M)) {
      real_T u[2];
      u[0] = (((Model_M->Timing.clockTick1+Model_M->Timing.clockTickH1*
                4294967296.0)) * 2.0);
      ;
      u[1] = Model_B.Integrator;
      rt_UpdateLogVar((LogVar *)Model_DW.ThetaGear_PWORK.LoggedData, u, 0);
    }
  }

  /* SignalGenerator: '<Root>/Signal Generator' */
  temp = Model_P.SignalGenerator_Frequency * Model_M->Timing.t[0];
  if (temp - floor(temp) >= 0.5) {
    Model_B.SignalGenerator = Model_P.SignalGenerator_Amplitude;
  } else {
    Model_B.SignalGenerator = -Model_P.SignalGenerator_Amplitude;
  }

  /* End of SignalGenerator: '<Root>/Signal Generator' */
  if (rtmIsMajorTimeStep(Model_M)) {
    /* Scope: '<Root>/Theta Ref' */
    if (rtmIsMajorTimeStep(Model_M)) {
      real_T u[2];
      u[0] = (((Model_M->Timing.clockTick1+Model_M->Timing.clockTickH1*
                4294967296.0)) * 2.0);
      ;
      u[1] = Model_B.SignalGenerator;
      rt_UpdateLogVar((LogVar *)Model_DW.ThetaRef_PWORK.LoggedData, u, 0);
    }
  }

  /* Gain: '<Root>/Kp' incorporates:
   *  Sum: '<Root>/Sum'
   */
  Model_B.Kp = (Model_B.SignalGenerator - Model_B.Integrator) * Model_P.Kp;
  if (rtmIsMajorTimeStep(Model_M)) {
    /* Scope: '<Root>/Vmot' */
    if (rtmIsMajorTimeStep(Model_M)) {
      real_T u[2];
      u[0] = (((Model_M->Timing.clockTick1+Model_M->Timing.clockTickH1*
                4294967296.0)) * 2.0);
      ;
      u[1] = Model_B.Kp;
      rt_UpdateLogVar((LogVar *)Model_DW.Vmot_PWORK.LoggedData, u, 0);
    }
  }

  /* TransferFcn: '<Root>/Transfer Fcn' */
  Model_B.TransferFcn = 0.0;
  Model_B.TransferFcn += Model_P.TransferFcn_C * Model_X.TransferFcn_CSTATE;
  if (rtmIsMajorTimeStep(Model_M)) {
    /* Matfile logging */
    rt_UpdateTXYLogVars(Model_M->rtwLogInfo, (Model_M->Timing.t));
  }                                    /* end MajorTimeStep */

  if (rtmIsMajorTimeStep(Model_M)) {
    /* signal main to stop simulation */
    {                                  /* Sample time: [0.0s, 0.0s] */
      if ((rtmGetTFinal(Model_M)!=-1) &&
          !((rtmGetTFinal(Model_M)-(((Model_M->Timing.clockTick1+
               Model_M->Timing.clockTickH1* 4294967296.0)) * 2.0)) >
            (((Model_M->Timing.clockTick1+Model_M->Timing.clockTickH1*
               4294967296.0)) * 2.0) * (DBL_EPSILON))) {
        rtmSetErrorStatus(Model_M, "Simulation finished");
      }
    }

    rt_ertODEUpdateContinuousStates(&Model_M->solverInfo);

    /* Update absolute time for base rate */
    /* The "clockTick0" counts the number of times the code of this task has
     * been executed. The absolute time is the multiplication of "clockTick0"
     * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
     * overflow during the application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick0 and the high bits
     * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
     */
    if (!(++Model_M->Timing.clockTick0)) {
      ++Model_M->Timing.clockTickH0;
    }

    Model_M->Timing.t[0] = rtsiGetSolverStopTime(&Model_M->solverInfo);

    {
      /* Update absolute timer for sample time: [2.0s, 0.0s] */
      /* The "clockTick1" counts the number of times the code of this task has
       * been executed. The resolution of this integer timer is 2.0, which is the step size
       * of the task. Size of "clockTick1" ensures timer will not overflow during the
       * application lifespan selected.
       * Timer of this task consists of two 32 bit unsigned integers.
       * The two integers represent the low bits Timing.clockTick1 and the high bits
       * Timing.clockTickH1. When the low bit overflows to 0, the high bits increment.
       */
      Model_M->Timing.clockTick1++;
      if (!Model_M->Timing.clockTick1) {
        Model_M->Timing.clockTickH1++;
      }
    }
  }                                    /* end MajorTimeStep */
}

/* Derivatives for root system: '<Root>' */
void Model_derivatives(void)
{
  XDot_Model_T *_rtXdot;
  _rtXdot = ((XDot_Model_T *) Model_M->ModelData.derivs);

  /* Derivatives for Integrator: '<Root>/Integrator' */
  _rtXdot->Integrator_CSTATE = Model_B.TransferFcn;

  /* Derivatives for TransferFcn: '<Root>/Transfer Fcn' */
  _rtXdot->TransferFcn_CSTATE = 0.0;
  _rtXdot->TransferFcn_CSTATE += Model_P.TransferFcn_A *
    Model_X.TransferFcn_CSTATE;
  _rtXdot->TransferFcn_CSTATE += Model_B.Kp;
}

/* Model initialize function */
void Model_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)Model_M, 0,
                sizeof(RT_MODEL_Model_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&Model_M->solverInfo, &Model_M->Timing.simTimeStep);
    rtsiSetTPtr(&Model_M->solverInfo, &rtmGetTPtr(Model_M));
    rtsiSetStepSizePtr(&Model_M->solverInfo, &Model_M->Timing.stepSize0);
    rtsiSetdXPtr(&Model_M->solverInfo, &Model_M->ModelData.derivs);
    rtsiSetContStatesPtr(&Model_M->solverInfo, (real_T **)
                         &Model_M->ModelData.contStates);
    rtsiSetNumContStatesPtr(&Model_M->solverInfo, &Model_M->Sizes.numContStates);
    rtsiSetNumPeriodicContStatesPtr(&Model_M->solverInfo,
      &Model_M->Sizes.numPeriodicContStates);
    rtsiSetPeriodicContStateIndicesPtr(&Model_M->solverInfo,
      &Model_M->ModelData.periodicContStateIndices);
    rtsiSetPeriodicContStateRangesPtr(&Model_M->solverInfo,
      &Model_M->ModelData.periodicContStateRanges);
    rtsiSetErrorStatusPtr(&Model_M->solverInfo, (&rtmGetErrorStatus(Model_M)));
    rtsiSetRTModelPtr(&Model_M->solverInfo, Model_M);
  }

  rtsiSetSimTimeStep(&Model_M->solverInfo, MAJOR_TIME_STEP);
  Model_M->ModelData.intgData.y = Model_M->ModelData.odeY;
  Model_M->ModelData.intgData.f[0] = Model_M->ModelData.odeF[0];
  Model_M->ModelData.intgData.f[1] = Model_M->ModelData.odeF[1];
  Model_M->ModelData.intgData.f[2] = Model_M->ModelData.odeF[2];
  Model_M->ModelData.contStates = ((X_Model_T *) &Model_X);
  rtsiSetSolverData(&Model_M->solverInfo, (void *)&Model_M->ModelData.intgData);
  rtsiSetSolverName(&Model_M->solverInfo,"ode3");
  rtmSetTPtr(Model_M, &Model_M->Timing.tArray[0]);
  rtmSetTFinal(Model_M, 100.0);
  Model_M->Timing.stepSize0 = 2.0;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    rt_DataLoggingInfo.loggingInterval = NULL;
    Model_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(Model_M->rtwLogInfo, (NULL));
    rtliSetLogXSignalPtrs(Model_M->rtwLogInfo, (NULL));
    rtliSetLogT(Model_M->rtwLogInfo, "tout");
    rtliSetLogX(Model_M->rtwLogInfo, "");
    rtliSetLogXFinal(Model_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(Model_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(Model_M->rtwLogInfo, 4);
    rtliSetLogMaxRows(Model_M->rtwLogInfo, 1000);
    rtliSetLogDecimation(Model_M->rtwLogInfo, 1);
    rtliSetLogY(Model_M->rtwLogInfo, "");
    rtliSetLogYSignalInfo(Model_M->rtwLogInfo, (NULL));
    rtliSetLogYSignalPtrs(Model_M->rtwLogInfo, (NULL));
  }

  /* block I/O */
  (void) memset(((void *) &Model_B), 0,
                sizeof(B_Model_T));

  /* states (continuous) */
  {
    (void) memset((void *)&Model_X, 0,
                  sizeof(X_Model_T));
  }

  /* states (dwork) */
  (void) memset((void *)&Model_DW, 0,
                sizeof(DW_Model_T));

  /* Matfile logging */
  rt_StartDataLoggingWithStartTime(Model_M->rtwLogInfo, 0.0, rtmGetTFinal
    (Model_M), Model_M->Timing.stepSize0, (&rtmGetErrorStatus(Model_M)));

  /* Start for Scope: '<Root>/Theta Gear' */
  {
    int_T numCols = 2;
    Model_DW.ThetaGear_PWORK.LoggedData = rt_CreateLogVar(
      Model_M->rtwLogInfo,
      0.0,
      rtmGetTFinal(Model_M),
      Model_M->Timing.stepSize0,
      (&rtmGetErrorStatus(Model_M)),
      "Og_sim",
      SS_DOUBLE,
      0,
      0,
      0,
      2,
      1,
      (int_T *)&numCols,
      NO_LOGVALDIMS,
      (NULL),
      (NULL),
      0,
      1,
      2.0,
      1);
    if (Model_DW.ThetaGear_PWORK.LoggedData == (NULL))
      return;
  }

  /* Start for Scope: '<Root>/Theta Ref' */
  {
    int_T numCols = 2;
    Model_DW.ThetaRef_PWORK.LoggedData = rt_CreateLogVar(
      Model_M->rtwLogInfo,
      0.0,
      rtmGetTFinal(Model_M),
      Model_M->Timing.stepSize0,
      (&rtmGetErrorStatus(Model_M)),
      "Oref_sim",
      SS_DOUBLE,
      0,
      0,
      0,
      2,
      1,
      (int_T *)&numCols,
      NO_LOGVALDIMS,
      (NULL),
      (NULL),
      0,
      1,
      2.0,
      1);
    if (Model_DW.ThetaRef_PWORK.LoggedData == (NULL))
      return;
  }

  /* Start for Scope: '<Root>/Vmot' */
  {
    int_T numCols = 2;
    Model_DW.Vmot_PWORK.LoggedData = rt_CreateLogVar(
      Model_M->rtwLogInfo,
      0.0,
      rtmGetTFinal(Model_M),
      Model_M->Timing.stepSize0,
      (&rtmGetErrorStatus(Model_M)),
      "Vmot_sim",
      SS_DOUBLE,
      0,
      0,
      0,
      2,
      1,
      (int_T *)&numCols,
      NO_LOGVALDIMS,
      (NULL),
      (NULL),
      0,
      1,
      2.0,
      1);
    if (Model_DW.Vmot_PWORK.LoggedData == (NULL))
      return;
  }

  /* InitializeConditions for Integrator: '<Root>/Integrator' */
  Model_X.Integrator_CSTATE = Model_P.Integrator_IC;

  /* InitializeConditions for TransferFcn: '<Root>/Transfer Fcn' */
  Model_X.TransferFcn_CSTATE = 0.0;
}

/* Model terminate function */
void Model_terminate(void)
{
  /* (no terminate code required) */
}
