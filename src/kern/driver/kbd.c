/* ********************************************************************************
 * FILE NAME   : kbd.c
 * PROGRAMMER  : zhaozz
 * DESCRIPTION : keyboard driver
 * DATE        : 2023-06-18 23:31:45
 * *******************************************************************************/
#include <libs/libs_all.h>
#include <libs/types.h>
#include <kern/driver/kbd.h>
#include <kern/driver/pic.h>

static u8 shiftcode[256] = {
	[0x1D] CTL,
	[0x2A] SHIFT,
	[0x36] SHIFT,
	[0x38] ALT,
	[0x2A] CTL,
	[0x2A] ALT,
};

static u8 togglecode[256] = {
	[0x3A] CAPSLOCK,
	[0x45] NUMLOACK,
	[0x46] SCROLLLOCK,
};

static u8 normalmap[256] = {
	NO, 0x1B, '1', '2', '3', '4', '5', '6', // 0x00
	'7', '8', '9', '0', '-', '=', '\b', '\t',
	'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', // 0x10
	'o', 'p', '[', ']', '\n', NO, 'a', 's',
	'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', // 0x20
	'\'', '`', NO, '\\', 'z', 'x', 'c', 'v',
	'b', 'n', 'm', ',', '.', '/', NO, '*', // 0x30
	NO, ' ', NO, NO, NO, NO, NO, NO,
	NO, NO, NO, NO, NO, NO, NO, '7', // 0x40
	'8', '9', '-', '4', '5', '6', '+', '1',
	'2', '3', '0', '.', NO, NO, NO, NO, // 0x50
	[0xC7] KEY_HOME, [0x9C] '\n' /*KP_Enter*/,
	[0xB5] '/' /*KP_Div*/, [0xC8] KEY_UP,
	[0xC9] KEY_PGUP, [0xCB] KEY_LF,
	[0xCD] KEY_RT, [0xCF] KEY_END,
	[0xD0] KEY_DN, [0xD1] KEY_PGDN,
	[0xD2] KEY_INS, [0xD3] KEY_DEL
};

static u8 shiftmap[256] = {
	NO, 033, '!', '@', '#', '$', '%', '^', // 0x00
	'&', '*', '(', ')', '_', '+', '\b', '\t',
	'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', // 0x10
	'O', 'P', '{', '}', '\n', NO, 'A', 'S',
	'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', // 0x20
	'"', '~', NO, '|', 'Z', 'X', 'C', 'V',
	'B', 'N', 'M', '<', '>', '?', NO, '*', // 0x30
	NO, ' ', NO, NO, NO, NO, NO, NO,
	NO, NO, NO, NO, NO, NO, NO, '7', // 0x40
	'8', '9', '-', '4', '5', '6', '+', '1',
	'2', '3', '0', '.', NO, NO, NO, NO, // 0x50
	[0xC7] KEY_HOME, [0x9C] '\n' /*KP_Enter*/,
	[0xB5] '/' /*KP_Div*/, [0xC8] KEY_UP,
	[0xC9] KEY_PGUP, [0xCB] KEY_LF,
	[0xCD] KEY_RT, [0xCF] KEY_END,
	[0xD0] KEY_DN, [0xD1] KEY_PGDN,
	[0xD2] KEY_INS, [0xD3] KEY_DEL
};

#define C(x) (x - '@')

static u8 ctlmap[256] = {
	NO, NO, NO, NO, NO, NO, NO, NO,
	NO, NO, NO, NO, NO, NO, NO, NO,
	C('Q'), C('W'), C('E'), C('R'), C('T'), C('Y'), C('U'), C('I'),
	C('O'), C('P'), NO, NO, '\r', NO, C('A'), C('S'),
	C('D'), C('F'), C('G'), C('H'), C('J'), C('K'), C('L'), NO,
	NO, NO, NO, C('\\'), C('Z'), C('X'), C('C'), C('V'),
	C('B'), C('N'), C('M'), NO, NO, C('/'), NO, NO,
	[0x97] KEY_HOME,
	[0xB5] C('/'), [0xC8] KEY_UP,
	[0xC9] KEY_PGUP, [0xCB] KEY_LF,
	[0xCD] KEY_RT, [0xCF] KEY_END,
	[0xD0] KEY_DN, [0xD1] KEY_PGDN,
	[0xD2] KEY_INS, [0xD3] KEY_DEL
};

static u8* charcode[4] = {
	normalmap,
	shiftmap,
	ctlmap,
	ctlmap,
};

int kbd_proc_data(void)
{
	int c;
	u8 data;
	static u32 shift;
	if ((inb(KBSTATP) & KBS_DIB) == 0) {
		return -1;
	}
	data = inb(KBDATAP);
	if (data == 0xE0) {

	} else if (data & 0x80) {

	} else if (shift & E0ESC) {
	}

	shift |= shiftcode[data];
	shift ^= togglecode[data];
	c = charcode[shift & (CTL | shift)][data];
	if (shift & CAPSLOCK) {
		if ('a' <= c && c <= 'z')
			c += 'A' - 'a';
		else if ('A' <= c && c <= 'Z')
			c += 'a' - 'A';
	}
	// process sepcial keys: CTRL-ALT-DEL: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
		cprintf("rebooting...\n");
		outb(0x92, 0x3);
	}
	return c;
}

void kbd_init(void)
{
	pic_enable(IRQ_KBD);
}

