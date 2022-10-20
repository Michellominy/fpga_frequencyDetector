/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0xfbc00daa */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/home/ise/FrequencyFinder/Top.vhd";
extern char *IEEE_P_1242562249;
extern char *WORK_P_2188849903;

char *ieee_p_1242562249_sub_1006216973935652998_1035706684(char *, char *, char *, char *, int );
char *ieee_p_1242562249_sub_10420449594411817395_1035706684(char *, char *, int , int );
unsigned char ieee_p_1242562249_sub_1434214030532789707_1035706684(char *, char *, char *, char *, char *);
int ieee_p_1242562249_sub_17802405650254020620_1035706684(char *, char *, char *);
int ieee_p_1242562249_sub_1871261289446890672_1035706684(char *, char *, char *);
char *ieee_p_1242562249_sub_2749763749646623249_1035706684(char *, char *, char *, char *, int );
char *ieee_p_1242562249_sub_3525738511873186323_1035706684(char *, char *, char *, char *, char *, char *);
char *ieee_p_1242562249_sub_4437083849341520093_1035706684(char *, char *, char *, char *);


static void work_a_2943448091_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    int t4;
    int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;

LAB0:    xsi_set_current_line(180, ng0);

LAB3:    t1 = (t0 + 3592U);
    t2 = *((char **)t1);
    t1 = (t0 + 4392U);
    t3 = *((char **)t1);
    t1 = (t0 + 12760U);
    t4 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t3, t1);
    t5 = (t4 - 0);
    t6 = (t5 * 1);
    xsi_vhdl_check_range_of_index(0, 63, 1, t4);
    t7 = (18U * t6);
    t8 = (0 + t7);
    t9 = (t2 + t8);
    t10 = (t0 + 8632);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    memcpy(t14, t9, 18U);
    xsi_driver_first_trans_fast(t10);

LAB2:    t15 = (t0 + 8520);
    *((int *)t15) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2943448091_3212880686_p_1(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    int t15;

LAB0:    xsi_set_current_line(183, ng0);
    t2 = (t0 + 992U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 8536);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(184, ng0);
    t4 = (t0 + 3432U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)3);
    if (t10 != 0)
        goto LAB8;

LAB10:    t2 = (t0 + 4392U);
    t4 = *((char **)t2);
    t2 = (t0 + 12760U);
    t15 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t4, t2);
    t1 = (t15 >= 32);
    if (t1 != 0)
        goto LAB11;

LAB12:
LAB9:    xsi_set_current_line(192, ng0);
    t2 = (t0 + 5192U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t3 = (t1 == (unsigned char)3);
    if (t3 != 0)
        goto LAB13;

LAB15:
LAB14:    goto LAB3;

LAB5:    t4 = (t0 + 1032U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(185, ng0);
    t4 = (t0 + 8696);
    t11 = (t4 + 56U);
    t12 = *((char **)t11);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    *((unsigned char *)t14) = (unsigned char)3;
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(186, ng0);
    t2 = (t0 + 8760);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    goto LAB9;

LAB11:    xsi_set_current_line(189, ng0);
    t5 = (t0 + 8760);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    *((unsigned char *)t13) = (unsigned char)3;
    xsi_driver_first_trans_fast(t5);
    goto LAB9;

LAB13:    xsi_set_current_line(193, ng0);
    t2 = (t0 + 8696);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t11 = (t8 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    goto LAB14;

}

static void work_a_2943448091_3212880686_p_2(char *t0)
{
    char t8[16];
    char t9[16];
    char t12[16];
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t10;
    char *t11;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    int t17;
    char *t18;
    char *t19;
    int t20;
    int t21;
    unsigned int t22;
    char *t23;

LAB0:    xsi_set_current_line(204, ng0);
    t2 = (t0 + 992U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 8552);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(205, ng0);
    t4 = (t0 + 4712U);
    t10 = *((char **)t4);
    t4 = (t0 + 12792U);
    t11 = ieee_p_1242562249_sub_4437083849341520093_1035706684(IEEE_P_1242562249, t9, t10, t4);
    t13 = (t0 + 4872U);
    t14 = *((char **)t13);
    t13 = (t0 + 12808U);
    t15 = ieee_p_1242562249_sub_4437083849341520093_1035706684(IEEE_P_1242562249, t12, t14, t13);
    t16 = ieee_p_1242562249_sub_3525738511873186323_1035706684(IEEE_P_1242562249, t8, t11, t9, t15, t12);
    t17 = ieee_p_1242562249_sub_1871261289446890672_1035706684(IEEE_P_1242562249, t16, t8);
    t18 = (t0 + 6728U);
    t19 = *((char **)t18);
    t18 = (t19 + 0);
    *((int *)t18) = t17;
    xsi_set_current_line(206, ng0);
    t2 = (t0 + 6488U);
    t4 = *((char **)t2);
    t17 = *((int *)t4);
    t2 = (t0 + 6728U);
    t5 = *((char **)t2);
    t20 = *((int *)t5);
    t1 = (t17 < t20);
    if (t1 != 0)
        goto LAB8;

LAB10:
LAB9:    xsi_set_current_line(210, ng0);
    t2 = (t0 + 4552U);
    t4 = *((char **)t2);
    t2 = (t0 + 12776U);
    t5 = ((WORK_P_2188849903) + 1288U);
    t10 = *((char **)t5);
    t17 = *((int *)t10);
    t20 = (t17 - 1);
    t5 = ieee_p_1242562249_sub_10420449594411817395_1035706684(IEEE_P_1242562249, t8, t20, 12);
    t1 = ieee_p_1242562249_sub_1434214030532789707_1035706684(IEEE_P_1242562249, t4, t2, t5, t8);
    if (t1 != 0)
        goto LAB11;

LAB13:
LAB12:    goto LAB3;

LAB5:    t4 = (t0 + 1032U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(207, ng0);
    t2 = (t0 + 6728U);
    t10 = *((char **)t2);
    t21 = *((int *)t10);
    t2 = (t0 + 6488U);
    t11 = *((char **)t2);
    t2 = (t11 + 0);
    *((int *)t2) = t21;
    xsi_set_current_line(208, ng0);
    t2 = (t0 + 4552U);
    t4 = *((char **)t2);
    t2 = (t0 + 12776U);
    t5 = ieee_p_1242562249_sub_2749763749646623249_1035706684(IEEE_P_1242562249, t8, t4, t2, 12);
    t10 = (t0 + 6608U);
    t11 = *((char **)t10);
    t10 = (t11 + 0);
    t13 = (t8 + 12U);
    t22 = *((unsigned int *)t13);
    t22 = (t22 * 1U);
    memcpy(t10, t5, t22);
    goto LAB9;

LAB11:    xsi_set_current_line(211, ng0);
    t11 = (t0 + 6608U);
    t13 = *((char **)t11);
    t11 = (t0 + 12840U);
    t14 = ieee_p_1242562249_sub_1006216973935652998_1035706684(IEEE_P_1242562249, t9, t13, t11, 1);
    t15 = (t0 + 8824);
    t16 = (t15 + 56U);
    t18 = *((char **)t16);
    t19 = (t18 + 56U);
    t23 = *((char **)t19);
    memcpy(t23, t14, 12U);
    xsi_driver_first_trans_fast(t15);
    xsi_set_current_line(212, ng0);
    t2 = (t0 + 6488U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;
    xsi_set_current_line(213, ng0);
    t2 = xsi_get_transient_memory(12U);
    memset(t2, 0, 12U);
    t4 = t2;
    memset(t4, (unsigned char)2, 12U);
    t5 = (t0 + 6608U);
    t10 = *((char **)t5);
    t5 = (t10 + 0);
    memcpy(t5, t2, 12U);
    goto LAB12;

}


extern void work_a_2943448091_3212880686_init()
{
	static char *pe[] = {(void *)work_a_2943448091_3212880686_p_0,(void *)work_a_2943448091_3212880686_p_1,(void *)work_a_2943448091_3212880686_p_2};
	xsi_register_didat("work_a_2943448091_3212880686", "isim/top_module_isim_beh.exe.sim/work/a_2943448091_3212880686.didat");
	xsi_register_executes(pe);
}
