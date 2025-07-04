/* Copyright 2023 Cheng Liren
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include <stdint.h>
#include "redox-w.h"
int spi_sck_pin = SPI_SCK_PIN;
int spi_miso_pin = SPI_MOSI_PIN;
int spi_mosi_pin = SPI_MISO_PIN;
int spi_cs_pin = SPI_CS_PIN;
uint8_t pm3610_irq_pin = PMW3610_IRQ_PIN;

uint32_t matrix_row_pins[ROWS] = MATRIX_ROW_PINS;
uint32_t matrix_col_pins[COLUMNS] = MATRIX_COL_PINS;

int main(void)
{
    extern int main_init();
    main_init();
}