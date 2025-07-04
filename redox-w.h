#ifndef __REDOX_W_FIRMWARE_CONFIG_REDOX_W_H__
#define __REDOX_W_FIRMWARE_CONFIG_REDOX_W_H__

#if defined(COMPILE_LEFT) && defined(COMPILE_RIGHT)
#error "Only one of COMPILE_LEFT and COMPILE_RIGHT can be defined at once."
#endif

#define NO_PIN 255

#define ROW2COL 0
#define COL2ROW 1

#ifndef DIODE_DIRECTION
#define DIODE_DIRECTION COL2ROW
#endif

#include "private_config.h"

#define COLUMNS 8
#define ROWS 8

#define MATRIX_COL_PINS { C01, C02, C03, C04, C05, C06, C07, C08 };
#define MATRIX_ROW_PINS { R01, R02, R03, R04, R05, R06, R07, R08 };

// Low frequency clock source to be used by the SoftDevice
#define NRF_CLOCK_LFCLKSRC      {.source        = NRF_CLOCK_LF_SRC_XTAL,            \
                                 .rc_ctiv       = 0,                                \
                                 .rc_temp_ctiv  = 0,                                \
                                 .xtal_accuracy = NRF_CLOCK_LF_XTAL_ACCURACY_20_PPM}

#endif /* __REDOX_W_FIRMWARE_CONFIG_REDOX_W_H__ */
