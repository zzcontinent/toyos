
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	f3 0f 1e fb          	endbr32 
  100004:	55                   	push   %ebp
  100005:	89 e5                	mov    %esp,%ebp
  100007:	83 ec 28             	sub    $0x28,%esp
	extern char edata[], end[];
	memset(edata, 0, end - edata);
  10000a:	b8 20 0d 11 00       	mov    $0x110d20,%eax
  10000f:	2d 16 fa 10 00       	sub    $0x10fa16,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 fa 10 00 	movl   $0x10fa16,(%esp)
  100027:	e8 17 2b 00 00       	call   102b43 <memset>

	cons_init();                // init the console
  10002c:	e8 50 15 00 00       	call   101581 <cons_init>

	const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 80 33 10 00 	movl   $0x103380,-0xc(%ebp)
	cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 9c 33 10 00 	movl   $0x10339c,(%esp)
  100046:	e8 39 02 00 00       	call   100284 <cprintf>

	print_kerninfo();
  10004b:	e8 f7 08 00 00       	call   100947 <print_kerninfo>

	grade_backtrace();
  100050:	e8 95 00 00 00       	call   1000ea <grade_backtrace>

	pmm_init();                 // init physical memory management
  100055:	e8 98 27 00 00       	call   1027f2 <pmm_init>

	pic_init();                 // init interrupt controller
  10005a:	e8 77 16 00 00       	call   1016d6 <pic_init>
	idt_init();                 // init interrupt descriptor table
  10005f:	e8 f7 17 00 00       	call   10185b <idt_init>

	clock_init();               // init clock interrupt
  100064:	e8 9d 0c 00 00       	call   100d06 <clock_init>
	intr_enable();              // enable irq interrupt
  100069:	e8 b4 17 00 00       	call   101822 <intr_enable>
	//LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
	// user/kernel mode switch test
	//lab1_switch_test();

	/* do nothing */
	while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
	grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	f3 0f 1e fb          	endbr32 
  100074:	55                   	push   %ebp
  100075:	89 e5                	mov    %esp,%ebp
  100077:	83 ec 18             	sub    $0x18,%esp
		mon_backtrace(0, NULL, NULL);
  10007a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100081:	00 
  100082:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100089:	00 
  10008a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100091:	e8 5a 0c 00 00       	call   100cf0 <mon_backtrace>
	}
  100096:	90                   	nop
  100097:	c9                   	leave  
  100098:	c3                   	ret    

00100099 <grade_backtrace1>:

void __attribute__((noinline))
	grade_backtrace1(int arg0, int arg1) {
  100099:	f3 0f 1e fb          	endbr32 
  10009d:	55                   	push   %ebp
  10009e:	89 e5                	mov    %esp,%ebp
  1000a0:	53                   	push   %ebx
  1000a1:	83 ec 14             	sub    $0x14,%esp
		grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a4:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000aa:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1000b0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000bc:	89 04 24             	mov    %eax,(%esp)
  1000bf:	e8 ac ff ff ff       	call   100070 <grade_backtrace2>
	}
  1000c4:	90                   	nop
  1000c5:	83 c4 14             	add    $0x14,%esp
  1000c8:	5b                   	pop    %ebx
  1000c9:	5d                   	pop    %ebp
  1000ca:	c3                   	ret    

001000cb <grade_backtrace0>:

void __attribute__((noinline))
	grade_backtrace0(int arg0, int arg1, int arg2) {
  1000cb:	f3 0f 1e fb          	endbr32 
  1000cf:	55                   	push   %ebp
  1000d0:	89 e5                	mov    %esp,%ebp
  1000d2:	83 ec 18             	sub    $0x18,%esp
		grade_backtrace1(arg0, arg2);
  1000d5:	8b 45 10             	mov    0x10(%ebp),%eax
  1000d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1000df:	89 04 24             	mov    %eax,(%esp)
  1000e2:	e8 b2 ff ff ff       	call   100099 <grade_backtrace1>
	}
  1000e7:	90                   	nop
  1000e8:	c9                   	leave  
  1000e9:	c3                   	ret    

001000ea <grade_backtrace>:

void
grade_backtrace(void) {
  1000ea:	f3 0f 1e fb          	endbr32 
  1000ee:	55                   	push   %ebp
  1000ef:	89 e5                	mov    %esp,%ebp
  1000f1:	83 ec 18             	sub    $0x18,%esp
	grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f4:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000f9:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100100:	ff 
  100101:	89 44 24 04          	mov    %eax,0x4(%esp)
  100105:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10010c:	e8 ba ff ff ff       	call   1000cb <grade_backtrace0>
}
  100111:	90                   	nop
  100112:	c9                   	leave  
  100113:	c3                   	ret    

00100114 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100114:	f3 0f 1e fb          	endbr32 
  100118:	55                   	push   %ebp
  100119:	89 e5                	mov    %esp,%ebp
  10011b:	83 ec 28             	sub    $0x28,%esp
	static int round = 0;
	uint16_t reg1, reg2, reg3, reg4;
	asm volatile (
  10011e:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100121:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100124:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100127:	8c 55 f0             	mov    %ss,-0x10(%ebp)
			"mov %%cs, %0;"
			"mov %%ds, %1;"
			"mov %%es, %2;"
			"mov %%ss, %3;"
			: "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
	cprintf("%d: @ring %d\n", round, reg1 & 3);
  10012a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10012e:	83 e0 03             	and    $0x3,%eax
  100131:	89 c2                	mov    %eax,%edx
  100133:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100138:	89 54 24 08          	mov    %edx,0x8(%esp)
  10013c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100140:	c7 04 24 a1 33 10 00 	movl   $0x1033a1,(%esp)
  100147:	e8 38 01 00 00       	call   100284 <cprintf>
	cprintf("%d:  cs = %x\n", round, reg1);
  10014c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100150:	89 c2                	mov    %eax,%edx
  100152:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100157:	89 54 24 08          	mov    %edx,0x8(%esp)
  10015b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10015f:	c7 04 24 af 33 10 00 	movl   $0x1033af,(%esp)
  100166:	e8 19 01 00 00       	call   100284 <cprintf>
	cprintf("%d:  ds = %x\n", round, reg2);
  10016b:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10016f:	89 c2                	mov    %eax,%edx
  100171:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100176:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10017e:	c7 04 24 bd 33 10 00 	movl   $0x1033bd,(%esp)
  100185:	e8 fa 00 00 00       	call   100284 <cprintf>
	cprintf("%d:  es = %x\n", round, reg3);
  10018a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10018e:	89 c2                	mov    %eax,%edx
  100190:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100195:	89 54 24 08          	mov    %edx,0x8(%esp)
  100199:	89 44 24 04          	mov    %eax,0x4(%esp)
  10019d:	c7 04 24 cb 33 10 00 	movl   $0x1033cb,(%esp)
  1001a4:	e8 db 00 00 00       	call   100284 <cprintf>
	cprintf("%d:  ss = %x\n", round, reg4);
  1001a9:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001ad:	89 c2                	mov    %eax,%edx
  1001af:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001bc:	c7 04 24 d9 33 10 00 	movl   $0x1033d9,(%esp)
  1001c3:	e8 bc 00 00 00       	call   100284 <cprintf>
	round ++;
  1001c8:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001cd:	40                   	inc    %eax
  1001ce:	a3 20 fa 10 00       	mov    %eax,0x10fa20
}
  1001d3:	90                   	nop
  1001d4:	c9                   	leave  
  1001d5:	c3                   	ret    

001001d6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001d6:	f3 0f 1e fb          	endbr32 
  1001da:	55                   	push   %ebp
  1001db:	89 e5                	mov    %esp,%ebp
	//LAB1 CHALLENGE 1 : TODO
}
  1001dd:	90                   	nop
  1001de:	5d                   	pop    %ebp
  1001df:	c3                   	ret    

001001e0 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001e0:	f3 0f 1e fb          	endbr32 
  1001e4:	55                   	push   %ebp
  1001e5:	89 e5                	mov    %esp,%ebp
	//LAB1 CHALLENGE 1 :  TODO
}
  1001e7:	90                   	nop
  1001e8:	5d                   	pop    %ebp
  1001e9:	c3                   	ret    

001001ea <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001ea:	f3 0f 1e fb          	endbr32 
  1001ee:	55                   	push   %ebp
  1001ef:	89 e5                	mov    %esp,%ebp
  1001f1:	83 ec 18             	sub    $0x18,%esp
	lab1_print_cur_status();
  1001f4:	e8 1b ff ff ff       	call   100114 <lab1_print_cur_status>
	cprintf("+++ switch to  user  mode +++\n");
  1001f9:	c7 04 24 e8 33 10 00 	movl   $0x1033e8,(%esp)
  100200:	e8 7f 00 00 00       	call   100284 <cprintf>
	lab1_switch_to_user();
  100205:	e8 cc ff ff ff       	call   1001d6 <lab1_switch_to_user>
	lab1_print_cur_status();
  10020a:	e8 05 ff ff ff       	call   100114 <lab1_print_cur_status>
	cprintf("+++ switch to kernel mode +++\n");
  10020f:	c7 04 24 08 34 10 00 	movl   $0x103408,(%esp)
  100216:	e8 69 00 00 00       	call   100284 <cprintf>
	lab1_switch_to_kernel();
  10021b:	e8 c0 ff ff ff       	call   1001e0 <lab1_switch_to_kernel>
	lab1_print_cur_status();
  100220:	e8 ef fe ff ff       	call   100114 <lab1_print_cur_status>
}
  100225:	90                   	nop
  100226:	c9                   	leave  
  100227:	c3                   	ret    

00100228 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100228:	f3 0f 1e fb          	endbr32 
  10022c:	55                   	push   %ebp
  10022d:	89 e5                	mov    %esp,%ebp
  10022f:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100232:	8b 45 08             	mov    0x8(%ebp),%eax
  100235:	89 04 24             	mov    %eax,(%esp)
  100238:	e8 75 13 00 00       	call   1015b2 <cons_putc>
    (*cnt) ++;
  10023d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100240:	8b 00                	mov    (%eax),%eax
  100242:	8d 50 01             	lea    0x1(%eax),%edx
  100245:	8b 45 0c             	mov    0xc(%ebp),%eax
  100248:	89 10                	mov    %edx,(%eax)
}
  10024a:	90                   	nop
  10024b:	c9                   	leave  
  10024c:	c3                   	ret    

0010024d <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10024d:	f3 0f 1e fb          	endbr32 
  100251:	55                   	push   %ebp
  100252:	89 e5                	mov    %esp,%ebp
  100254:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100257:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10025e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100261:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100265:	8b 45 08             	mov    0x8(%ebp),%eax
  100268:	89 44 24 08          	mov    %eax,0x8(%esp)
  10026c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10026f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100273:	c7 04 24 28 02 10 00 	movl   $0x100228,(%esp)
  10027a:	e8 30 2c 00 00       	call   102eaf <vprintfmt>
    return cnt;
  10027f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100282:	c9                   	leave  
  100283:	c3                   	ret    

00100284 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100284:	f3 0f 1e fb          	endbr32 
  100288:	55                   	push   %ebp
  100289:	89 e5                	mov    %esp,%ebp
  10028b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10028e:	8d 45 0c             	lea    0xc(%ebp),%eax
  100291:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100297:	89 44 24 04          	mov    %eax,0x4(%esp)
  10029b:	8b 45 08             	mov    0x8(%ebp),%eax
  10029e:	89 04 24             	mov    %eax,(%esp)
  1002a1:	e8 a7 ff ff ff       	call   10024d <vcprintf>
  1002a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002ac:	c9                   	leave  
  1002ad:	c3                   	ret    

001002ae <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002ae:	f3 0f 1e fb          	endbr32 
  1002b2:	55                   	push   %ebp
  1002b3:	89 e5                	mov    %esp,%ebp
  1002b5:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002bb:	89 04 24             	mov    %eax,(%esp)
  1002be:	e8 ef 12 00 00       	call   1015b2 <cons_putc>
}
  1002c3:	90                   	nop
  1002c4:	c9                   	leave  
  1002c5:	c3                   	ret    

001002c6 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002c6:	f3 0f 1e fb          	endbr32 
  1002ca:	55                   	push   %ebp
  1002cb:	89 e5                	mov    %esp,%ebp
  1002cd:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002d7:	eb 13                	jmp    1002ec <cputs+0x26>
        cputch(c, &cnt);
  1002d9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002dd:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002e0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002e4:	89 04 24             	mov    %eax,(%esp)
  1002e7:	e8 3c ff ff ff       	call   100228 <cputch>
    while ((c = *str ++) != '\0') {
  1002ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ef:	8d 50 01             	lea    0x1(%eax),%edx
  1002f2:	89 55 08             	mov    %edx,0x8(%ebp)
  1002f5:	0f b6 00             	movzbl (%eax),%eax
  1002f8:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002fb:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002ff:	75 d8                	jne    1002d9 <cputs+0x13>
    }
    cputch('\n', &cnt);
  100301:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100304:	89 44 24 04          	mov    %eax,0x4(%esp)
  100308:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10030f:	e8 14 ff ff ff       	call   100228 <cputch>
    return cnt;
  100314:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100317:	c9                   	leave  
  100318:	c3                   	ret    

00100319 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100319:	f3 0f 1e fb          	endbr32 
  10031d:	55                   	push   %ebp
  10031e:	89 e5                	mov    %esp,%ebp
  100320:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100323:	90                   	nop
  100324:	e8 b7 12 00 00       	call   1015e0 <cons_getc>
  100329:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10032c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100330:	74 f2                	je     100324 <getchar+0xb>
        /* do nothing */;
    return c;
  100332:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100335:	c9                   	leave  
  100336:	c3                   	ret    

00100337 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100337:	f3 0f 1e fb          	endbr32 
  10033b:	55                   	push   %ebp
  10033c:	89 e5                	mov    %esp,%ebp
  10033e:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100341:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100345:	74 13                	je     10035a <readline+0x23>
        cprintf("%s", prompt);
  100347:	8b 45 08             	mov    0x8(%ebp),%eax
  10034a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034e:	c7 04 24 27 34 10 00 	movl   $0x103427,(%esp)
  100355:	e8 2a ff ff ff       	call   100284 <cprintf>
    }
    int i = 0, c;
  10035a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100361:	e8 b3 ff ff ff       	call   100319 <getchar>
  100366:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100369:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10036d:	79 07                	jns    100376 <readline+0x3f>
            return NULL;
  10036f:	b8 00 00 00 00       	mov    $0x0,%eax
  100374:	eb 78                	jmp    1003ee <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100376:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10037a:	7e 28                	jle    1003a4 <readline+0x6d>
  10037c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100383:	7f 1f                	jg     1003a4 <readline+0x6d>
            cputchar(c);
  100385:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100388:	89 04 24             	mov    %eax,(%esp)
  10038b:	e8 1e ff ff ff       	call   1002ae <cputchar>
            buf[i ++] = c;
  100390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100393:	8d 50 01             	lea    0x1(%eax),%edx
  100396:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100399:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10039c:	88 90 40 fa 10 00    	mov    %dl,0x10fa40(%eax)
  1003a2:	eb 45                	jmp    1003e9 <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003a4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003a8:	75 16                	jne    1003c0 <readline+0x89>
  1003aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ae:	7e 10                	jle    1003c0 <readline+0x89>
            cputchar(c);
  1003b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003b3:	89 04 24             	mov    %eax,(%esp)
  1003b6:	e8 f3 fe ff ff       	call   1002ae <cputchar>
            i --;
  1003bb:	ff 4d f4             	decl   -0xc(%ebp)
  1003be:	eb 29                	jmp    1003e9 <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  1003c0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003c4:	74 06                	je     1003cc <readline+0x95>
  1003c6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003ca:	75 95                	jne    100361 <readline+0x2a>
            cputchar(c);
  1003cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003cf:	89 04 24             	mov    %eax,(%esp)
  1003d2:	e8 d7 fe ff ff       	call   1002ae <cputchar>
            buf[i] = '\0';
  1003d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003da:	05 40 fa 10 00       	add    $0x10fa40,%eax
  1003df:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003e2:	b8 40 fa 10 00       	mov    $0x10fa40,%eax
  1003e7:	eb 05                	jmp    1003ee <readline+0xb7>
        c = getchar();
  1003e9:	e9 73 ff ff ff       	jmp    100361 <readline+0x2a>
        }
    }
}
  1003ee:	c9                   	leave  
  1003ef:	c3                   	ret    

001003f0 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003f0:	f3 0f 1e fb          	endbr32 
  1003f4:	55                   	push   %ebp
  1003f5:	89 e5                	mov    %esp,%ebp
  1003f7:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003fa:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  1003ff:	85 c0                	test   %eax,%eax
  100401:	75 5b                	jne    10045e <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100403:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  10040a:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  10040d:	8d 45 14             	lea    0x14(%ebp),%eax
  100410:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100413:	8b 45 0c             	mov    0xc(%ebp),%eax
  100416:	89 44 24 08          	mov    %eax,0x8(%esp)
  10041a:	8b 45 08             	mov    0x8(%ebp),%eax
  10041d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100421:	c7 04 24 2a 34 10 00 	movl   $0x10342a,(%esp)
  100428:	e8 57 fe ff ff       	call   100284 <cprintf>
    vcprintf(fmt, ap);
  10042d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100430:	89 44 24 04          	mov    %eax,0x4(%esp)
  100434:	8b 45 10             	mov    0x10(%ebp),%eax
  100437:	89 04 24             	mov    %eax,(%esp)
  10043a:	e8 0e fe ff ff       	call   10024d <vcprintf>
    cprintf("\n");
  10043f:	c7 04 24 46 34 10 00 	movl   $0x103446,(%esp)
  100446:	e8 39 fe ff ff       	call   100284 <cprintf>
    
    cprintf("stack trackback:\n");
  10044b:	c7 04 24 48 34 10 00 	movl   $0x103448,(%esp)
  100452:	e8 2d fe ff ff       	call   100284 <cprintf>
    print_stackframe();
  100457:	e8 3d 06 00 00       	call   100a99 <print_stackframe>
  10045c:	eb 01                	jmp    10045f <__panic+0x6f>
        goto panic_dead;
  10045e:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10045f:	e8 ca 13 00 00       	call   10182e <intr_disable>
    while (1) {
        kmonitor(NULL);
  100464:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10046b:	e8 a7 07 00 00       	call   100c17 <kmonitor>
  100470:	eb f2                	jmp    100464 <__panic+0x74>

00100472 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100472:	f3 0f 1e fb          	endbr32 
  100476:	55                   	push   %ebp
  100477:	89 e5                	mov    %esp,%ebp
  100479:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  10047c:	8d 45 14             	lea    0x14(%ebp),%eax
  10047f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100482:	8b 45 0c             	mov    0xc(%ebp),%eax
  100485:	89 44 24 08          	mov    %eax,0x8(%esp)
  100489:	8b 45 08             	mov    0x8(%ebp),%eax
  10048c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100490:	c7 04 24 5a 34 10 00 	movl   $0x10345a,(%esp)
  100497:	e8 e8 fd ff ff       	call   100284 <cprintf>
    vcprintf(fmt, ap);
  10049c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10049f:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004a3:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a6:	89 04 24             	mov    %eax,(%esp)
  1004a9:	e8 9f fd ff ff       	call   10024d <vcprintf>
    cprintf("\n");
  1004ae:	c7 04 24 46 34 10 00 	movl   $0x103446,(%esp)
  1004b5:	e8 ca fd ff ff       	call   100284 <cprintf>
    va_end(ap);
}
  1004ba:	90                   	nop
  1004bb:	c9                   	leave  
  1004bc:	c3                   	ret    

001004bd <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004bd:	f3 0f 1e fb          	endbr32 
  1004c1:	55                   	push   %ebp
  1004c2:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004c4:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  1004c9:	5d                   	pop    %ebp
  1004ca:	c3                   	ret    

001004cb <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
		int type, uintptr_t addr) {
  1004cb:	f3 0f 1e fb          	endbr32 
  1004cf:	55                   	push   %ebp
  1004d0:	89 e5                	mov    %esp,%ebp
  1004d2:	83 ec 20             	sub    $0x20,%esp
	int l = *region_left, r = *region_right, any_matches = 0;
  1004d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d8:	8b 00                	mov    (%eax),%eax
  1004da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004dd:	8b 45 10             	mov    0x10(%ebp),%eax
  1004e0:	8b 00                	mov    (%eax),%eax
  1004e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	while (l <= r) {
  1004ec:	e9 ca 00 00 00       	jmp    1005bb <stab_binsearch+0xf0>
		int true_m = (l + r) / 2, m = true_m;
  1004f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004f7:	01 d0                	add    %edx,%eax
  1004f9:	89 c2                	mov    %eax,%edx
  1004fb:	c1 ea 1f             	shr    $0x1f,%edx
  1004fe:	01 d0                	add    %edx,%eax
  100500:	d1 f8                	sar    %eax
  100502:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100505:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100508:	89 45 f0             	mov    %eax,-0x10(%ebp)

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type) {
  10050b:	eb 03                	jmp    100510 <stab_binsearch+0x45>
			m --;
  10050d:	ff 4d f0             	decl   -0x10(%ebp)
		while (m >= l && stabs[m].n_type != type) {
  100510:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100513:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100516:	7c 1f                	jl     100537 <stab_binsearch+0x6c>
  100518:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10051b:	89 d0                	mov    %edx,%eax
  10051d:	01 c0                	add    %eax,%eax
  10051f:	01 d0                	add    %edx,%eax
  100521:	c1 e0 02             	shl    $0x2,%eax
  100524:	89 c2                	mov    %eax,%edx
  100526:	8b 45 08             	mov    0x8(%ebp),%eax
  100529:	01 d0                	add    %edx,%eax
  10052b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10052f:	0f b6 c0             	movzbl %al,%eax
  100532:	39 45 14             	cmp    %eax,0x14(%ebp)
  100535:	75 d6                	jne    10050d <stab_binsearch+0x42>
		}
		if (m < l) {    // no match in [l, m]
  100537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10053a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10053d:	7d 09                	jge    100548 <stab_binsearch+0x7d>
			l = true_m + 1;
  10053f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100542:	40                   	inc    %eax
  100543:	89 45 fc             	mov    %eax,-0x4(%ebp)
			continue;
  100546:	eb 73                	jmp    1005bb <stab_binsearch+0xf0>
		}

		// actual binary search
		any_matches = 1;
  100548:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
		if (stabs[m].n_value < addr) {
  10054f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100552:	89 d0                	mov    %edx,%eax
  100554:	01 c0                	add    %eax,%eax
  100556:	01 d0                	add    %edx,%eax
  100558:	c1 e0 02             	shl    $0x2,%eax
  10055b:	89 c2                	mov    %eax,%edx
  10055d:	8b 45 08             	mov    0x8(%ebp),%eax
  100560:	01 d0                	add    %edx,%eax
  100562:	8b 40 08             	mov    0x8(%eax),%eax
  100565:	39 45 18             	cmp    %eax,0x18(%ebp)
  100568:	76 11                	jbe    10057b <stab_binsearch+0xb0>
			*region_left = m;
  10056a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100570:	89 10                	mov    %edx,(%eax)
			l = true_m + 1;
  100572:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100575:	40                   	inc    %eax
  100576:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100579:	eb 40                	jmp    1005bb <stab_binsearch+0xf0>
		} else if (stabs[m].n_value > addr) {
  10057b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10057e:	89 d0                	mov    %edx,%eax
  100580:	01 c0                	add    %eax,%eax
  100582:	01 d0                	add    %edx,%eax
  100584:	c1 e0 02             	shl    $0x2,%eax
  100587:	89 c2                	mov    %eax,%edx
  100589:	8b 45 08             	mov    0x8(%ebp),%eax
  10058c:	01 d0                	add    %edx,%eax
  10058e:	8b 40 08             	mov    0x8(%eax),%eax
  100591:	39 45 18             	cmp    %eax,0x18(%ebp)
  100594:	73 14                	jae    1005aa <stab_binsearch+0xdf>
			*region_right = m - 1;
  100596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100599:	8d 50 ff             	lea    -0x1(%eax),%edx
  10059c:	8b 45 10             	mov    0x10(%ebp),%eax
  10059f:	89 10                	mov    %edx,(%eax)
			r = m - 1;
  1005a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005a4:	48                   	dec    %eax
  1005a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005a8:	eb 11                	jmp    1005bb <stab_binsearch+0xf0>
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
  1005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b0:	89 10                	mov    %edx,(%eax)
			l = m;
  1005b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
			addr ++;
  1005b8:	ff 45 18             	incl   0x18(%ebp)
	while (l <= r) {
  1005bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005c1:	0f 8e 2a ff ff ff    	jle    1004f1 <stab_binsearch+0x26>
		}
	}

	if (!any_matches) {
  1005c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005cb:	75 0f                	jne    1005dc <stab_binsearch+0x111>
		*region_right = *region_left - 1;
  1005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d0:	8b 00                	mov    (%eax),%eax
  1005d2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005d5:	8b 45 10             	mov    0x10(%ebp),%eax
  1005d8:	89 10                	mov    %edx,(%eax)
		l = *region_right;
		for (; l > *region_left && stabs[l].n_type != type; l --)
			/* do nothing */;
		*region_left = l;
	}
}
  1005da:	eb 3e                	jmp    10061a <stab_binsearch+0x14f>
		l = *region_right;
  1005dc:	8b 45 10             	mov    0x10(%ebp),%eax
  1005df:	8b 00                	mov    (%eax),%eax
  1005e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
		for (; l > *region_left && stabs[l].n_type != type; l --)
  1005e4:	eb 03                	jmp    1005e9 <stab_binsearch+0x11e>
  1005e6:	ff 4d fc             	decl   -0x4(%ebp)
  1005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ec:	8b 00                	mov    (%eax),%eax
  1005ee:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005f1:	7e 1f                	jle    100612 <stab_binsearch+0x147>
  1005f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005f6:	89 d0                	mov    %edx,%eax
  1005f8:	01 c0                	add    %eax,%eax
  1005fa:	01 d0                	add    %edx,%eax
  1005fc:	c1 e0 02             	shl    $0x2,%eax
  1005ff:	89 c2                	mov    %eax,%edx
  100601:	8b 45 08             	mov    0x8(%ebp),%eax
  100604:	01 d0                	add    %edx,%eax
  100606:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10060a:	0f b6 c0             	movzbl %al,%eax
  10060d:	39 45 14             	cmp    %eax,0x14(%ebp)
  100610:	75 d4                	jne    1005e6 <stab_binsearch+0x11b>
		*region_left = l;
  100612:	8b 45 0c             	mov    0xc(%ebp),%eax
  100615:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100618:	89 10                	mov    %edx,(%eax)
}
  10061a:	90                   	nop
  10061b:	c9                   	leave  
  10061c:	c3                   	ret    

0010061d <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10061d:	f3 0f 1e fb          	endbr32 
  100621:	55                   	push   %ebp
  100622:	89 e5                	mov    %esp,%ebp
  100624:	83 ec 58             	sub    $0x58,%esp
	const struct stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;

	info->eip_file = "<unknown>";
  100627:	8b 45 0c             	mov    0xc(%ebp),%eax
  10062a:	c7 00 78 34 10 00    	movl   $0x103478,(%eax)
	info->eip_line = 0;
  100630:	8b 45 0c             	mov    0xc(%ebp),%eax
  100633:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	info->eip_fn_name = "<unknown>";
  10063a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063d:	c7 40 08 78 34 10 00 	movl   $0x103478,0x8(%eax)
	info->eip_fn_namelen = 9;
  100644:	8b 45 0c             	mov    0xc(%ebp),%eax
  100647:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
	info->eip_fn_addr = addr;
  10064e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100651:	8b 55 08             	mov    0x8(%ebp),%edx
  100654:	89 50 10             	mov    %edx,0x10(%eax)
	info->eip_fn_narg = 0;
  100657:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	stabs = __STAB_BEGIN__;
  100661:	c7 45 f4 6c 3c 10 00 	movl   $0x103c6c,-0xc(%ebp)
	stab_end = __STAB_END__;
  100668:	c7 45 f0 84 c6 10 00 	movl   $0x10c684,-0x10(%ebp)
	stabstr = __STABSTR_BEGIN__;
  10066f:	c7 45 ec 85 c6 10 00 	movl   $0x10c685,-0x14(%ebp)
	stabstr_end = __STABSTR_END__;
  100676:	c7 45 e8 52 e7 10 00 	movl   $0x10e752,-0x18(%ebp)

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10067d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100680:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100683:	76 0b                	jbe    100690 <debuginfo_eip+0x73>
  100685:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100688:	48                   	dec    %eax
  100689:	0f b6 00             	movzbl (%eax),%eax
  10068c:	84 c0                	test   %al,%al
  10068e:	74 0a                	je     10069a <debuginfo_eip+0x7d>
		return -1;
  100690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100695:	e9 ab 02 00 00       	jmp    100945 <debuginfo_eip+0x328>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	int lfile = 0, rfile = (stab_end - stabs) - 1;
  10069a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006a4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006a7:	c1 f8 02             	sar    $0x2,%eax
  1006aa:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006b0:	48                   	dec    %eax
  1006b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1006b7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006bb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006c2:	00 
  1006c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006d4:	89 04 24             	mov    %eax,(%esp)
  1006d7:	e8 ef fd ff ff       	call   1004cb <stab_binsearch>
	if (lfile == 0)
  1006dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006df:	85 c0                	test   %eax,%eax
  1006e1:	75 0a                	jne    1006ed <debuginfo_eip+0xd0>
		return -1;
  1006e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006e8:	e9 58 02 00 00       	jmp    100945 <debuginfo_eip+0x328>

	// Search within that file's stabs for the function definition
	// (N_FUN).
	int lfun = lfile, rfun = rfile;
  1006ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int lline, rline;
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1006fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  100700:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100707:	00 
  100708:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10070b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10070f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100712:	89 44 24 04          	mov    %eax,0x4(%esp)
  100716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100719:	89 04 24             	mov    %eax,(%esp)
  10071c:	e8 aa fd ff ff       	call   1004cb <stab_binsearch>

	if (lfun <= rfun) {
  100721:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100724:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100727:	39 c2                	cmp    %eax,%edx
  100729:	7f 78                	jg     1007a3 <debuginfo_eip+0x186>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10072b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10072e:	89 c2                	mov    %eax,%edx
  100730:	89 d0                	mov    %edx,%eax
  100732:	01 c0                	add    %eax,%eax
  100734:	01 d0                	add    %edx,%eax
  100736:	c1 e0 02             	shl    $0x2,%eax
  100739:	89 c2                	mov    %eax,%edx
  10073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10073e:	01 d0                	add    %edx,%eax
  100740:	8b 10                	mov    (%eax),%edx
  100742:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100745:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100748:	39 c2                	cmp    %eax,%edx
  10074a:	73 22                	jae    10076e <debuginfo_eip+0x151>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10074c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10074f:	89 c2                	mov    %eax,%edx
  100751:	89 d0                	mov    %edx,%eax
  100753:	01 c0                	add    %eax,%eax
  100755:	01 d0                	add    %edx,%eax
  100757:	c1 e0 02             	shl    $0x2,%eax
  10075a:	89 c2                	mov    %eax,%edx
  10075c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075f:	01 d0                	add    %edx,%eax
  100761:	8b 10                	mov    (%eax),%edx
  100763:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100766:	01 c2                	add    %eax,%edx
  100768:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076b:	89 50 08             	mov    %edx,0x8(%eax)
		}
		info->eip_fn_addr = stabs[lfun].n_value;
  10076e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100771:	89 c2                	mov    %eax,%edx
  100773:	89 d0                	mov    %edx,%eax
  100775:	01 c0                	add    %eax,%eax
  100777:	01 d0                	add    %edx,%eax
  100779:	c1 e0 02             	shl    $0x2,%eax
  10077c:	89 c2                	mov    %eax,%edx
  10077e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100781:	01 d0                	add    %edx,%eax
  100783:	8b 50 08             	mov    0x8(%eax),%edx
  100786:	8b 45 0c             	mov    0xc(%ebp),%eax
  100789:	89 50 10             	mov    %edx,0x10(%eax)
		addr -= info->eip_fn_addr;
  10078c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078f:	8b 40 10             	mov    0x10(%eax),%eax
  100792:	29 45 08             	sub    %eax,0x8(%ebp)
		// Search within the function definition for the line number.
		lline = lfun;
  100795:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100798:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
  10079b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10079e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007a1:	eb 15                	jmp    1007b8 <debuginfo_eip+0x19b>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
  1007a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a6:	8b 55 08             	mov    0x8(%ebp),%edx
  1007a9:	89 50 10             	mov    %edx,0x10(%eax)
		lline = lfile;
  1007ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007af:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
  1007b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
	}
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007bb:	8b 40 08             	mov    0x8(%eax),%eax
  1007be:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007c5:	00 
  1007c6:	89 04 24             	mov    %eax,(%esp)
  1007c9:	e8 e9 21 00 00       	call   1029b7 <strfind>
  1007ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  1007d1:	8b 52 08             	mov    0x8(%edx),%edx
  1007d4:	29 d0                	sub    %edx,%eax
  1007d6:	89 c2                	mov    %eax,%edx
  1007d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007db:	89 50 0c             	mov    %edx,0xc(%eax)

	// Search within [lline, rline] for the line number stab.
	// If found, set info->eip_line to the right line number.
	// If not found, return -1.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007de:	8b 45 08             	mov    0x8(%ebp),%eax
  1007e1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007e5:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007ec:	00 
  1007ed:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007f4:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007fe:	89 04 24             	mov    %eax,(%esp)
  100801:	e8 c5 fc ff ff       	call   1004cb <stab_binsearch>
	if (lline <= rline) {
  100806:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100809:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10080c:	39 c2                	cmp    %eax,%edx
  10080e:	7f 23                	jg     100833 <debuginfo_eip+0x216>
		info->eip_line = stabs[rline].n_desc;
  100810:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100813:	89 c2                	mov    %eax,%edx
  100815:	89 d0                	mov    %edx,%eax
  100817:	01 c0                	add    %eax,%eax
  100819:	01 d0                	add    %edx,%eax
  10081b:	c1 e0 02             	shl    $0x2,%eax
  10081e:	89 c2                	mov    %eax,%edx
  100820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100823:	01 d0                	add    %edx,%eax
  100825:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100829:	89 c2                	mov    %eax,%edx
  10082b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082e:	89 50 04             	mov    %edx,0x4(%eax)

	// Search backwards from the line number for the relevant filename stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
  100831:	eb 11                	jmp    100844 <debuginfo_eip+0x227>
		return -1;
  100833:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100838:	e9 08 01 00 00       	jmp    100945 <debuginfo_eip+0x328>
			&& stabs[lline].n_type != N_SOL
			&& (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
		lline --;
  10083d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100840:	48                   	dec    %eax
  100841:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (lline >= lfile
  100844:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100847:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10084a:	39 c2                	cmp    %eax,%edx
  10084c:	7c 56                	jl     1008a4 <debuginfo_eip+0x287>
			&& stabs[lline].n_type != N_SOL
  10084e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100851:	89 c2                	mov    %eax,%edx
  100853:	89 d0                	mov    %edx,%eax
  100855:	01 c0                	add    %eax,%eax
  100857:	01 d0                	add    %edx,%eax
  100859:	c1 e0 02             	shl    $0x2,%eax
  10085c:	89 c2                	mov    %eax,%edx
  10085e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100861:	01 d0                	add    %edx,%eax
  100863:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100867:	3c 84                	cmp    $0x84,%al
  100869:	74 39                	je     1008a4 <debuginfo_eip+0x287>
			&& (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10086b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10086e:	89 c2                	mov    %eax,%edx
  100870:	89 d0                	mov    %edx,%eax
  100872:	01 c0                	add    %eax,%eax
  100874:	01 d0                	add    %edx,%eax
  100876:	c1 e0 02             	shl    $0x2,%eax
  100879:	89 c2                	mov    %eax,%edx
  10087b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10087e:	01 d0                	add    %edx,%eax
  100880:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100884:	3c 64                	cmp    $0x64,%al
  100886:	75 b5                	jne    10083d <debuginfo_eip+0x220>
  100888:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10088b:	89 c2                	mov    %eax,%edx
  10088d:	89 d0                	mov    %edx,%eax
  10088f:	01 c0                	add    %eax,%eax
  100891:	01 d0                	add    %edx,%eax
  100893:	c1 e0 02             	shl    $0x2,%eax
  100896:	89 c2                	mov    %eax,%edx
  100898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10089b:	01 d0                	add    %edx,%eax
  10089d:	8b 40 08             	mov    0x8(%eax),%eax
  1008a0:	85 c0                	test   %eax,%eax
  1008a2:	74 99                	je     10083d <debuginfo_eip+0x220>
	}
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008aa:	39 c2                	cmp    %eax,%edx
  1008ac:	7c 42                	jl     1008f0 <debuginfo_eip+0x2d3>
  1008ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008b1:	89 c2                	mov    %eax,%edx
  1008b3:	89 d0                	mov    %edx,%eax
  1008b5:	01 c0                	add    %eax,%eax
  1008b7:	01 d0                	add    %edx,%eax
  1008b9:	c1 e0 02             	shl    $0x2,%eax
  1008bc:	89 c2                	mov    %eax,%edx
  1008be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008c1:	01 d0                	add    %edx,%eax
  1008c3:	8b 10                	mov    (%eax),%edx
  1008c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008c8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1008cb:	39 c2                	cmp    %eax,%edx
  1008cd:	73 21                	jae    1008f0 <debuginfo_eip+0x2d3>
		info->eip_file = stabstr + stabs[lline].n_strx;
  1008cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d2:	89 c2                	mov    %eax,%edx
  1008d4:	89 d0                	mov    %edx,%eax
  1008d6:	01 c0                	add    %eax,%eax
  1008d8:	01 d0                	add    %edx,%eax
  1008da:	c1 e0 02             	shl    $0x2,%eax
  1008dd:	89 c2                	mov    %eax,%edx
  1008df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e2:	01 d0                	add    %edx,%eax
  1008e4:	8b 10                	mov    (%eax),%edx
  1008e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008e9:	01 c2                	add    %eax,%edx
  1008eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ee:	89 10                	mov    %edx,(%eax)
	}

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun) {
  1008f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008f6:	39 c2                	cmp    %eax,%edx
  1008f8:	7d 46                	jge    100940 <debuginfo_eip+0x323>
		for (lline = lfun + 1;
  1008fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008fd:	40                   	inc    %eax
  1008fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100901:	eb 16                	jmp    100919 <debuginfo_eip+0x2fc>
				lline < rfun && stabs[lline].n_type == N_PSYM;
				lline ++) {
			info->eip_fn_narg ++;
  100903:	8b 45 0c             	mov    0xc(%ebp),%eax
  100906:	8b 40 14             	mov    0x14(%eax),%eax
  100909:	8d 50 01             	lea    0x1(%eax),%edx
  10090c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10090f:	89 50 14             	mov    %edx,0x14(%eax)
				lline ++) {
  100912:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100915:	40                   	inc    %eax
  100916:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				lline < rfun && stabs[lline].n_type == N_PSYM;
  100919:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10091c:	8b 45 d8             	mov    -0x28(%ebp),%eax
		for (lline = lfun + 1;
  10091f:	39 c2                	cmp    %eax,%edx
  100921:	7d 1d                	jge    100940 <debuginfo_eip+0x323>
				lline < rfun && stabs[lline].n_type == N_PSYM;
  100923:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100926:	89 c2                	mov    %eax,%edx
  100928:	89 d0                	mov    %edx,%eax
  10092a:	01 c0                	add    %eax,%eax
  10092c:	01 d0                	add    %edx,%eax
  10092e:	c1 e0 02             	shl    $0x2,%eax
  100931:	89 c2                	mov    %eax,%edx
  100933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100936:	01 d0                	add    %edx,%eax
  100938:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10093c:	3c a0                	cmp    $0xa0,%al
  10093e:	74 c3                	je     100903 <debuginfo_eip+0x2e6>
		}
	}
	return 0;
  100940:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100945:	c9                   	leave  
  100946:	c3                   	ret    

00100947 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100947:	f3 0f 1e fb          	endbr32 
  10094b:	55                   	push   %ebp
  10094c:	89 e5                	mov    %esp,%ebp
  10094e:	83 ec 18             	sub    $0x18,%esp
	extern char etext[], edata[], end[], kern_init[];
	cprintf("Special kernel symbols:\n");
  100951:	c7 04 24 82 34 10 00 	movl   $0x103482,(%esp)
  100958:	e8 27 f9 ff ff       	call   100284 <cprintf>
	cprintf("  entry  0x%08x (phys)\n", kern_init);
  10095d:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100964:	00 
  100965:	c7 04 24 9b 34 10 00 	movl   $0x10349b,(%esp)
  10096c:	e8 13 f9 ff ff       	call   100284 <cprintf>
	cprintf("  etext  0x%08x (phys)\n", etext);
  100971:	c7 44 24 04 67 33 10 	movl   $0x103367,0x4(%esp)
  100978:	00 
  100979:	c7 04 24 b3 34 10 00 	movl   $0x1034b3,(%esp)
  100980:	e8 ff f8 ff ff       	call   100284 <cprintf>
	cprintf("  edata  0x%08x (phys)\n", edata);
  100985:	c7 44 24 04 16 fa 10 	movl   $0x10fa16,0x4(%esp)
  10098c:	00 
  10098d:	c7 04 24 cb 34 10 00 	movl   $0x1034cb,(%esp)
  100994:	e8 eb f8 ff ff       	call   100284 <cprintf>
	cprintf("  end    0x%08x (phys)\n", end);
  100999:	c7 44 24 04 20 0d 11 	movl   $0x110d20,0x4(%esp)
  1009a0:	00 
  1009a1:	c7 04 24 e3 34 10 00 	movl   $0x1034e3,(%esp)
  1009a8:	e8 d7 f8 ff ff       	call   100284 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009ad:	b8 20 0d 11 00       	mov    $0x110d20,%eax
  1009b2:	2d 00 00 10 00       	sub    $0x100000,%eax
  1009b7:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009bc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009c2:	85 c0                	test   %eax,%eax
  1009c4:	0f 48 c2             	cmovs  %edx,%eax
  1009c7:	c1 f8 0a             	sar    $0xa,%eax
  1009ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ce:	c7 04 24 fc 34 10 00 	movl   $0x1034fc,(%esp)
  1009d5:	e8 aa f8 ff ff       	call   100284 <cprintf>
}
  1009da:	90                   	nop
  1009db:	c9                   	leave  
  1009dc:	c3                   	ret    

001009dd <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009dd:	f3 0f 1e fb          	endbr32 
  1009e1:	55                   	push   %ebp
  1009e2:	89 e5                	mov    %esp,%ebp
  1009e4:	81 ec 48 01 00 00    	sub    $0x148,%esp
	struct eipdebuginfo info;
	if (debuginfo_eip(eip, &info) != 0) {
  1009ea:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1009f4:	89 04 24             	mov    %eax,(%esp)
  1009f7:	e8 21 fc ff ff       	call   10061d <debuginfo_eip>
  1009fc:	85 c0                	test   %eax,%eax
  1009fe:	74 15                	je     100a15 <print_debuginfo+0x38>
		cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a00:	8b 45 08             	mov    0x8(%ebp),%eax
  100a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a07:	c7 04 24 26 35 10 00 	movl   $0x103526,(%esp)
  100a0e:	e8 71 f8 ff ff       	call   100284 <cprintf>
		}
		fnname[j] = '\0';
		cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
				fnname, eip - info.eip_fn_addr);
	}
}
  100a13:	eb 6c                	jmp    100a81 <print_debuginfo+0xa4>
		for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a1c:	eb 1b                	jmp    100a39 <print_debuginfo+0x5c>
			fnname[j] = info.eip_fn_name[j];
  100a1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a24:	01 d0                	add    %edx,%eax
  100a26:	0f b6 10             	movzbl (%eax),%edx
  100a29:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a32:	01 c8                	add    %ecx,%eax
  100a34:	88 10                	mov    %dl,(%eax)
		for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a36:	ff 45 f4             	incl   -0xc(%ebp)
  100a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a3c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a3f:	7c dd                	jl     100a1e <print_debuginfo+0x41>
		fnname[j] = '\0';
  100a41:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a4a:	01 d0                	add    %edx,%eax
  100a4c:	c6 00 00             	movb   $0x0,(%eax)
				fnname, eip - info.eip_fn_addr);
  100a4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
		cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a52:	8b 55 08             	mov    0x8(%ebp),%edx
  100a55:	89 d1                	mov    %edx,%ecx
  100a57:	29 c1                	sub    %eax,%ecx
  100a59:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a5f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a63:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a69:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a6d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a71:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a75:	c7 04 24 42 35 10 00 	movl   $0x103542,(%esp)
  100a7c:	e8 03 f8 ff ff       	call   100284 <cprintf>
}
  100a81:	90                   	nop
  100a82:	c9                   	leave  
  100a83:	c3                   	ret    

00100a84 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a84:	f3 0f 1e fb          	endbr32 
  100a88:	55                   	push   %ebp
  100a89:	89 e5                	mov    %esp,%ebp
  100a8b:	83 ec 10             	sub    $0x10,%esp
	uint32_t eip;
	asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a8e:	8b 45 04             	mov    0x4(%ebp),%eax
  100a91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return eip;
  100a94:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a97:	c9                   	leave  
  100a98:	c3                   	ret    

00100a99 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a99:	f3 0f 1e fb          	endbr32 
  100a9d:	55                   	push   %ebp
  100a9e:	89 e5                	mov    %esp,%ebp
	 *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
	 *    (3.5) popup a calling stackframe
	 *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
	 *                   the calling funciton's ebp = ss:[ebp]
	 */
}
  100aa0:	90                   	nop
  100aa1:	5d                   	pop    %ebp
  100aa2:	c3                   	ret    

00100aa3 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100aa3:	f3 0f 1e fb          	endbr32 
  100aa7:	55                   	push   %ebp
  100aa8:	89 e5                	mov    %esp,%ebp
  100aaa:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100aad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ab4:	eb 0c                	jmp    100ac2 <parse+0x1f>
            *buf ++ = '\0';
  100ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  100ab9:	8d 50 01             	lea    0x1(%eax),%edx
  100abc:	89 55 08             	mov    %edx,0x8(%ebp)
  100abf:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac5:	0f b6 00             	movzbl (%eax),%eax
  100ac8:	84 c0                	test   %al,%al
  100aca:	74 1d                	je     100ae9 <parse+0x46>
  100acc:	8b 45 08             	mov    0x8(%ebp),%eax
  100acf:	0f b6 00             	movzbl (%eax),%eax
  100ad2:	0f be c0             	movsbl %al,%eax
  100ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ad9:	c7 04 24 d4 35 10 00 	movl   $0x1035d4,(%esp)
  100ae0:	e8 9c 1e 00 00       	call   102981 <strchr>
  100ae5:	85 c0                	test   %eax,%eax
  100ae7:	75 cd                	jne    100ab6 <parse+0x13>
        }
        if (*buf == '\0') {
  100ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  100aec:	0f b6 00             	movzbl (%eax),%eax
  100aef:	84 c0                	test   %al,%al
  100af1:	74 65                	je     100b58 <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100af3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100af7:	75 14                	jne    100b0d <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100af9:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b00:	00 
  100b01:	c7 04 24 d9 35 10 00 	movl   $0x1035d9,(%esp)
  100b08:	e8 77 f7 ff ff       	call   100284 <cprintf>
        }
        argv[argc ++] = buf;
  100b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b10:	8d 50 01             	lea    0x1(%eax),%edx
  100b13:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b16:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b20:	01 c2                	add    %eax,%edx
  100b22:	8b 45 08             	mov    0x8(%ebp),%eax
  100b25:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b27:	eb 03                	jmp    100b2c <parse+0x89>
            buf ++;
  100b29:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b2f:	0f b6 00             	movzbl (%eax),%eax
  100b32:	84 c0                	test   %al,%al
  100b34:	74 8c                	je     100ac2 <parse+0x1f>
  100b36:	8b 45 08             	mov    0x8(%ebp),%eax
  100b39:	0f b6 00             	movzbl (%eax),%eax
  100b3c:	0f be c0             	movsbl %al,%eax
  100b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b43:	c7 04 24 d4 35 10 00 	movl   $0x1035d4,(%esp)
  100b4a:	e8 32 1e 00 00       	call   102981 <strchr>
  100b4f:	85 c0                	test   %eax,%eax
  100b51:	74 d6                	je     100b29 <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b53:	e9 6a ff ff ff       	jmp    100ac2 <parse+0x1f>
            break;
  100b58:	90                   	nop
        }
    }
    return argc;
  100b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b5c:	c9                   	leave  
  100b5d:	c3                   	ret    

00100b5e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b5e:	f3 0f 1e fb          	endbr32 
  100b62:	55                   	push   %ebp
  100b63:	89 e5                	mov    %esp,%ebp
  100b65:	53                   	push   %ebx
  100b66:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b69:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b70:	8b 45 08             	mov    0x8(%ebp),%eax
  100b73:	89 04 24             	mov    %eax,(%esp)
  100b76:	e8 28 ff ff ff       	call   100aa3 <parse>
  100b7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b82:	75 0a                	jne    100b8e <runcmd+0x30>
        return 0;
  100b84:	b8 00 00 00 00       	mov    $0x0,%eax
  100b89:	e9 83 00 00 00       	jmp    100c11 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b95:	eb 5a                	jmp    100bf1 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b97:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b9d:	89 d0                	mov    %edx,%eax
  100b9f:	01 c0                	add    %eax,%eax
  100ba1:	01 d0                	add    %edx,%eax
  100ba3:	c1 e0 02             	shl    $0x2,%eax
  100ba6:	05 00 f0 10 00       	add    $0x10f000,%eax
  100bab:	8b 00                	mov    (%eax),%eax
  100bad:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100bb1:	89 04 24             	mov    %eax,(%esp)
  100bb4:	e8 24 1d 00 00       	call   1028dd <strcmp>
  100bb9:	85 c0                	test   %eax,%eax
  100bbb:	75 31                	jne    100bee <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100bbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bc0:	89 d0                	mov    %edx,%eax
  100bc2:	01 c0                	add    %eax,%eax
  100bc4:	01 d0                	add    %edx,%eax
  100bc6:	c1 e0 02             	shl    $0x2,%eax
  100bc9:	05 08 f0 10 00       	add    $0x10f008,%eax
  100bce:	8b 10                	mov    (%eax),%edx
  100bd0:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bd3:	83 c0 04             	add    $0x4,%eax
  100bd6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100bd9:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100bdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100bdf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100be3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100be7:	89 1c 24             	mov    %ebx,(%esp)
  100bea:	ff d2                	call   *%edx
  100bec:	eb 23                	jmp    100c11 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100bee:	ff 45 f4             	incl   -0xc(%ebp)
  100bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bf4:	83 f8 02             	cmp    $0x2,%eax
  100bf7:	76 9e                	jbe    100b97 <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bf9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c00:	c7 04 24 f7 35 10 00 	movl   $0x1035f7,(%esp)
  100c07:	e8 78 f6 ff ff       	call   100284 <cprintf>
    return 0;
  100c0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c11:	83 c4 64             	add    $0x64,%esp
  100c14:	5b                   	pop    %ebx
  100c15:	5d                   	pop    %ebp
  100c16:	c3                   	ret    

00100c17 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c17:	f3 0f 1e fb          	endbr32 
  100c1b:	55                   	push   %ebp
  100c1c:	89 e5                	mov    %esp,%ebp
  100c1e:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c21:	c7 04 24 10 36 10 00 	movl   $0x103610,(%esp)
  100c28:	e8 57 f6 ff ff       	call   100284 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c2d:	c7 04 24 38 36 10 00 	movl   $0x103638,(%esp)
  100c34:	e8 4b f6 ff ff       	call   100284 <cprintf>

    if (tf != NULL) {
  100c39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c3d:	74 0b                	je     100c4a <kmonitor+0x33>
        print_trapframe(tf);
  100c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c42:	89 04 24             	mov    %eax,(%esp)
  100c45:	e8 69 0c 00 00       	call   1018b3 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c4a:	c7 04 24 5d 36 10 00 	movl   $0x10365d,(%esp)
  100c51:	e8 e1 f6 ff ff       	call   100337 <readline>
  100c56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c5d:	74 eb                	je     100c4a <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c62:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c69:	89 04 24             	mov    %eax,(%esp)
  100c6c:	e8 ed fe ff ff       	call   100b5e <runcmd>
  100c71:	85 c0                	test   %eax,%eax
  100c73:	78 02                	js     100c77 <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100c75:	eb d3                	jmp    100c4a <kmonitor+0x33>
                break;
  100c77:	90                   	nop
            }
        }
    }
}
  100c78:	90                   	nop
  100c79:	c9                   	leave  
  100c7a:	c3                   	ret    

00100c7b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c7b:	f3 0f 1e fb          	endbr32 
  100c7f:	55                   	push   %ebp
  100c80:	89 e5                	mov    %esp,%ebp
  100c82:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c8c:	eb 3d                	jmp    100ccb <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c91:	89 d0                	mov    %edx,%eax
  100c93:	01 c0                	add    %eax,%eax
  100c95:	01 d0                	add    %edx,%eax
  100c97:	c1 e0 02             	shl    $0x2,%eax
  100c9a:	05 04 f0 10 00       	add    $0x10f004,%eax
  100c9f:	8b 08                	mov    (%eax),%ecx
  100ca1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ca4:	89 d0                	mov    %edx,%eax
  100ca6:	01 c0                	add    %eax,%eax
  100ca8:	01 d0                	add    %edx,%eax
  100caa:	c1 e0 02             	shl    $0x2,%eax
  100cad:	05 00 f0 10 00       	add    $0x10f000,%eax
  100cb2:	8b 00                	mov    (%eax),%eax
  100cb4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100cb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cbc:	c7 04 24 61 36 10 00 	movl   $0x103661,(%esp)
  100cc3:	e8 bc f5 ff ff       	call   100284 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100cc8:	ff 45 f4             	incl   -0xc(%ebp)
  100ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cce:	83 f8 02             	cmp    $0x2,%eax
  100cd1:	76 bb                	jbe    100c8e <mon_help+0x13>
    }
    return 0;
  100cd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cd8:	c9                   	leave  
  100cd9:	c3                   	ret    

00100cda <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cda:	f3 0f 1e fb          	endbr32 
  100cde:	55                   	push   %ebp
  100cdf:	89 e5                	mov    %esp,%ebp
  100ce1:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100ce4:	e8 5e fc ff ff       	call   100947 <print_kerninfo>
    return 0;
  100ce9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cee:	c9                   	leave  
  100cef:	c3                   	ret    

00100cf0 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cf0:	f3 0f 1e fb          	endbr32 
  100cf4:	55                   	push   %ebp
  100cf5:	89 e5                	mov    %esp,%ebp
  100cf7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cfa:	e8 9a fd ff ff       	call   100a99 <print_stackframe>
    return 0;
  100cff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d04:	c9                   	leave  
  100d05:	c3                   	ret    

00100d06 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d06:	f3 0f 1e fb          	endbr32 
  100d0a:	55                   	push   %ebp
  100d0b:	89 e5                	mov    %esp,%ebp
  100d0d:	83 ec 28             	sub    $0x28,%esp
  100d10:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d16:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d1a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d1e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d22:	ee                   	out    %al,(%dx)
}
  100d23:	90                   	nop
  100d24:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d2a:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d2e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d32:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d36:	ee                   	out    %al,(%dx)
}
  100d37:	90                   	nop
  100d38:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100d3e:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d42:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d46:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d4a:	ee                   	out    %al,(%dx)
}
  100d4b:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d4c:	c7 05 08 09 11 00 00 	movl   $0x0,0x110908
  100d53:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d56:	c7 04 24 6a 36 10 00 	movl   $0x10366a,(%esp)
  100d5d:	e8 22 f5 ff ff       	call   100284 <cprintf>
    pic_enable(IRQ_TIMER);
  100d62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d69:	e8 31 09 00 00       	call   10169f <pic_enable>
}
  100d6e:	90                   	nop
  100d6f:	c9                   	leave  
  100d70:	c3                   	ret    

00100d71 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100d71:	f3 0f 1e fb          	endbr32 
  100d75:	55                   	push   %ebp
  100d76:	89 e5                	mov    %esp,%ebp
  100d78:	83 ec 10             	sub    $0x10,%esp
  100d7b:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100d81:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100d85:	89 c2                	mov    %eax,%edx
  100d87:	ec                   	in     (%dx),%al
  100d88:	88 45 f1             	mov    %al,-0xf(%ebp)
  100d8b:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100d91:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100d95:	89 c2                	mov    %eax,%edx
  100d97:	ec                   	in     (%dx),%al
  100d98:	88 45 f5             	mov    %al,-0xb(%ebp)
  100d9b:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100da1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100da5:	89 c2                	mov    %eax,%edx
  100da7:	ec                   	in     (%dx),%al
  100da8:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dab:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100db1:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100db5:	89 c2                	mov    %eax,%edx
  100db7:	ec                   	in     (%dx),%al
  100db8:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100dbb:	90                   	nop
  100dbc:	c9                   	leave  
  100dbd:	c3                   	ret    

00100dbe <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100dbe:	f3 0f 1e fb          	endbr32 
  100dc2:	55                   	push   %ebp
  100dc3:	89 e5                	mov    %esp,%ebp
  100dc5:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100dc8:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100dcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dd2:	0f b7 00             	movzwl (%eax),%eax
  100dd5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100dd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ddc:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100de1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100de4:	0f b7 00             	movzwl (%eax),%eax
  100de7:	0f b7 c0             	movzwl %ax,%eax
  100dea:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100def:	74 12                	je     100e03 <cga_init+0x45>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100df1:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100df8:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100dff:	b4 03 
  100e01:	eb 13                	jmp    100e16 <cga_init+0x58>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e06:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e0a:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e0d:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100e14:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e16:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e1d:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e21:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e25:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e29:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100e2d:	ee                   	out    %al,(%dx)
}
  100e2e:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e2f:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e36:	40                   	inc    %eax
  100e37:	0f b7 c0             	movzwl %ax,%eax
  100e3a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e3e:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100e42:	89 c2                	mov    %eax,%edx
  100e44:	ec                   	in     (%dx),%al
  100e45:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100e48:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e4c:	0f b6 c0             	movzbl %al,%eax
  100e4f:	c1 e0 08             	shl    $0x8,%eax
  100e52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e55:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e5c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100e60:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e64:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e68:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e6c:	ee                   	out    %al,(%dx)
}
  100e6d:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100e6e:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e75:	40                   	inc    %eax
  100e76:	0f b7 c0             	movzwl %ax,%eax
  100e79:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e7d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e81:	89 c2                	mov    %eax,%edx
  100e83:	ec                   	in     (%dx),%al
  100e84:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100e87:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e8b:	0f b6 c0             	movzbl %al,%eax
  100e8e:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e94:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100e9c:	0f b7 c0             	movzwl %ax,%eax
  100e9f:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100ea5:	90                   	nop
  100ea6:	c9                   	leave  
  100ea7:	c3                   	ret    

00100ea8 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ea8:	f3 0f 1e fb          	endbr32 
  100eac:	55                   	push   %ebp
  100ead:	89 e5                	mov    %esp,%ebp
  100eaf:	83 ec 48             	sub    $0x48,%esp
  100eb2:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100eb8:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ebc:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100ec0:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100ec4:	ee                   	out    %al,(%dx)
}
  100ec5:	90                   	nop
  100ec6:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100ecc:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ed0:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100ed4:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100ed8:	ee                   	out    %al,(%dx)
}
  100ed9:	90                   	nop
  100eda:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100ee0:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ee4:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100ee8:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100eec:	ee                   	out    %al,(%dx)
}
  100eed:	90                   	nop
  100eee:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100ef4:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ef8:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100efc:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f00:	ee                   	out    %al,(%dx)
}
  100f01:	90                   	nop
  100f02:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f08:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f0c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f10:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f14:	ee                   	out    %al,(%dx)
}
  100f15:	90                   	nop
  100f16:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f1c:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f20:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f24:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f28:	ee                   	out    %al,(%dx)
}
  100f29:	90                   	nop
  100f2a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f30:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f34:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f38:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f3c:	ee                   	out    %al,(%dx)
}
  100f3d:	90                   	nop
  100f3e:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f44:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f48:	89 c2                	mov    %eax,%edx
  100f4a:	ec                   	in     (%dx),%al
  100f4b:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f4e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f52:	3c ff                	cmp    $0xff,%al
  100f54:	0f 95 c0             	setne  %al
  100f57:	0f b6 c0             	movzbl %al,%eax
  100f5a:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  100f5f:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f65:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f69:	89 c2                	mov    %eax,%edx
  100f6b:	ec                   	in     (%dx),%al
  100f6c:	88 45 f1             	mov    %al,-0xf(%ebp)
  100f6f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100f75:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100f79:	89 c2                	mov    %eax,%edx
  100f7b:	ec                   	in     (%dx),%al
  100f7c:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f7f:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  100f84:	85 c0                	test   %eax,%eax
  100f86:	74 0c                	je     100f94 <serial_init+0xec>
        pic_enable(IRQ_COM1);
  100f88:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100f8f:	e8 0b 07 00 00       	call   10169f <pic_enable>
    }
}
  100f94:	90                   	nop
  100f95:	c9                   	leave  
  100f96:	c3                   	ret    

00100f97 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100f97:	f3 0f 1e fb          	endbr32 
  100f9b:	55                   	push   %ebp
  100f9c:	89 e5                	mov    %esp,%ebp
  100f9e:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fa1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fa8:	eb 08                	jmp    100fb2 <lpt_putc_sub+0x1b>
        delay();
  100faa:	e8 c2 fd ff ff       	call   100d71 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100faf:	ff 45 fc             	incl   -0x4(%ebp)
  100fb2:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fb8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fbc:	89 c2                	mov    %eax,%edx
  100fbe:	ec                   	in     (%dx),%al
  100fbf:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fc2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100fc6:	84 c0                	test   %al,%al
  100fc8:	78 09                	js     100fd3 <lpt_putc_sub+0x3c>
  100fca:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fd1:	7e d7                	jle    100faa <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  100fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  100fd6:	0f b6 c0             	movzbl %al,%eax
  100fd9:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  100fdf:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fe2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100fe6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fea:	ee                   	out    %al,(%dx)
}
  100feb:	90                   	nop
  100fec:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  100ff2:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ff6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ffa:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ffe:	ee                   	out    %al,(%dx)
}
  100fff:	90                   	nop
  101000:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101006:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10100a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10100e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101012:	ee                   	out    %al,(%dx)
}
  101013:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101014:	90                   	nop
  101015:	c9                   	leave  
  101016:	c3                   	ret    

00101017 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101017:	f3 0f 1e fb          	endbr32 
  10101b:	55                   	push   %ebp
  10101c:	89 e5                	mov    %esp,%ebp
  10101e:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101021:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101025:	74 0d                	je     101034 <lpt_putc+0x1d>
        lpt_putc_sub(c);
  101027:	8b 45 08             	mov    0x8(%ebp),%eax
  10102a:	89 04 24             	mov    %eax,(%esp)
  10102d:	e8 65 ff ff ff       	call   100f97 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101032:	eb 24                	jmp    101058 <lpt_putc+0x41>
        lpt_putc_sub('\b');
  101034:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10103b:	e8 57 ff ff ff       	call   100f97 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101040:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101047:	e8 4b ff ff ff       	call   100f97 <lpt_putc_sub>
        lpt_putc_sub('\b');
  10104c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101053:	e8 3f ff ff ff       	call   100f97 <lpt_putc_sub>
}
  101058:	90                   	nop
  101059:	c9                   	leave  
  10105a:	c3                   	ret    

0010105b <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10105b:	f3 0f 1e fb          	endbr32 
  10105f:	55                   	push   %ebp
  101060:	89 e5                	mov    %esp,%ebp
  101062:	53                   	push   %ebx
  101063:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101066:	8b 45 08             	mov    0x8(%ebp),%eax
  101069:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10106e:	85 c0                	test   %eax,%eax
  101070:	75 07                	jne    101079 <cga_putc+0x1e>
        c |= 0x0700;
  101072:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101079:	8b 45 08             	mov    0x8(%ebp),%eax
  10107c:	0f b6 c0             	movzbl %al,%eax
  10107f:	83 f8 0d             	cmp    $0xd,%eax
  101082:	74 72                	je     1010f6 <cga_putc+0x9b>
  101084:	83 f8 0d             	cmp    $0xd,%eax
  101087:	0f 8f a3 00 00 00    	jg     101130 <cga_putc+0xd5>
  10108d:	83 f8 08             	cmp    $0x8,%eax
  101090:	74 0a                	je     10109c <cga_putc+0x41>
  101092:	83 f8 0a             	cmp    $0xa,%eax
  101095:	74 4c                	je     1010e3 <cga_putc+0x88>
  101097:	e9 94 00 00 00       	jmp    101130 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  10109c:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1010a3:	85 c0                	test   %eax,%eax
  1010a5:	0f 84 af 00 00 00    	je     10115a <cga_putc+0xff>
            crt_pos --;
  1010ab:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1010b2:	48                   	dec    %eax
  1010b3:	0f b7 c0             	movzwl %ax,%eax
  1010b6:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bf:	98                   	cwtl   
  1010c0:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010c5:	98                   	cwtl   
  1010c6:	83 c8 20             	or     $0x20,%eax
  1010c9:	98                   	cwtl   
  1010ca:	8b 15 60 fe 10 00    	mov    0x10fe60,%edx
  1010d0:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  1010d7:	01 c9                	add    %ecx,%ecx
  1010d9:	01 ca                	add    %ecx,%edx
  1010db:	0f b7 c0             	movzwl %ax,%eax
  1010de:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010e1:	eb 77                	jmp    10115a <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  1010e3:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1010ea:	83 c0 50             	add    $0x50,%eax
  1010ed:	0f b7 c0             	movzwl %ax,%eax
  1010f0:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010f6:	0f b7 1d 64 fe 10 00 	movzwl 0x10fe64,%ebx
  1010fd:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  101104:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101109:	89 c8                	mov    %ecx,%eax
  10110b:	f7 e2                	mul    %edx
  10110d:	c1 ea 06             	shr    $0x6,%edx
  101110:	89 d0                	mov    %edx,%eax
  101112:	c1 e0 02             	shl    $0x2,%eax
  101115:	01 d0                	add    %edx,%eax
  101117:	c1 e0 04             	shl    $0x4,%eax
  10111a:	29 c1                	sub    %eax,%ecx
  10111c:	89 c8                	mov    %ecx,%eax
  10111e:	0f b7 c0             	movzwl %ax,%eax
  101121:	29 c3                	sub    %eax,%ebx
  101123:	89 d8                	mov    %ebx,%eax
  101125:	0f b7 c0             	movzwl %ax,%eax
  101128:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  10112e:	eb 2b                	jmp    10115b <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101130:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  101136:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10113d:	8d 50 01             	lea    0x1(%eax),%edx
  101140:	0f b7 d2             	movzwl %dx,%edx
  101143:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  10114a:	01 c0                	add    %eax,%eax
  10114c:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10114f:	8b 45 08             	mov    0x8(%ebp),%eax
  101152:	0f b7 c0             	movzwl %ax,%eax
  101155:	66 89 02             	mov    %ax,(%edx)
        break;
  101158:	eb 01                	jmp    10115b <cga_putc+0x100>
        break;
  10115a:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10115b:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101162:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101167:	76 5d                	jbe    1011c6 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101169:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  10116e:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101174:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  101179:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101180:	00 
  101181:	89 54 24 04          	mov    %edx,0x4(%esp)
  101185:	89 04 24             	mov    %eax,(%esp)
  101188:	e8 f9 19 00 00       	call   102b86 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10118d:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101194:	eb 14                	jmp    1011aa <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  101196:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  10119b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10119e:	01 d2                	add    %edx,%edx
  1011a0:	01 d0                	add    %edx,%eax
  1011a2:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011a7:	ff 45 f4             	incl   -0xc(%ebp)
  1011aa:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011b1:	7e e3                	jle    101196 <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  1011b3:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011ba:	83 e8 50             	sub    $0x50,%eax
  1011bd:	0f b7 c0             	movzwl %ax,%eax
  1011c0:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011c6:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  1011cd:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1011d1:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1011d5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1011d9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1011dd:	ee                   	out    %al,(%dx)
}
  1011de:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1011df:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011e6:	c1 e8 08             	shr    $0x8,%eax
  1011e9:	0f b7 c0             	movzwl %ax,%eax
  1011ec:	0f b6 c0             	movzbl %al,%eax
  1011ef:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  1011f6:	42                   	inc    %edx
  1011f7:	0f b7 d2             	movzwl %dx,%edx
  1011fa:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1011fe:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101201:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101205:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101209:	ee                   	out    %al,(%dx)
}
  10120a:	90                   	nop
    outb(addr_6845, 15);
  10120b:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  101212:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101216:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10121a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10121e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101222:	ee                   	out    %al,(%dx)
}
  101223:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101224:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10122b:	0f b6 c0             	movzbl %al,%eax
  10122e:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  101235:	42                   	inc    %edx
  101236:	0f b7 d2             	movzwl %dx,%edx
  101239:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  10123d:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101240:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101244:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101248:	ee                   	out    %al,(%dx)
}
  101249:	90                   	nop
}
  10124a:	90                   	nop
  10124b:	83 c4 34             	add    $0x34,%esp
  10124e:	5b                   	pop    %ebx
  10124f:	5d                   	pop    %ebp
  101250:	c3                   	ret    

00101251 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101251:	f3 0f 1e fb          	endbr32 
  101255:	55                   	push   %ebp
  101256:	89 e5                	mov    %esp,%ebp
  101258:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10125b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101262:	eb 08                	jmp    10126c <serial_putc_sub+0x1b>
        delay();
  101264:	e8 08 fb ff ff       	call   100d71 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101269:	ff 45 fc             	incl   -0x4(%ebp)
  10126c:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101272:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101276:	89 c2                	mov    %eax,%edx
  101278:	ec                   	in     (%dx),%al
  101279:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10127c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101280:	0f b6 c0             	movzbl %al,%eax
  101283:	83 e0 20             	and    $0x20,%eax
  101286:	85 c0                	test   %eax,%eax
  101288:	75 09                	jne    101293 <serial_putc_sub+0x42>
  10128a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101291:	7e d1                	jle    101264 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  101293:	8b 45 08             	mov    0x8(%ebp),%eax
  101296:	0f b6 c0             	movzbl %al,%eax
  101299:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10129f:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012a2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012a6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012aa:	ee                   	out    %al,(%dx)
}
  1012ab:	90                   	nop
}
  1012ac:	90                   	nop
  1012ad:	c9                   	leave  
  1012ae:	c3                   	ret    

001012af <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012af:	f3 0f 1e fb          	endbr32 
  1012b3:	55                   	push   %ebp
  1012b4:	89 e5                	mov    %esp,%ebp
  1012b6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012b9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012bd:	74 0d                	je     1012cc <serial_putc+0x1d>
        serial_putc_sub(c);
  1012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1012c2:	89 04 24             	mov    %eax,(%esp)
  1012c5:	e8 87 ff ff ff       	call   101251 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012ca:	eb 24                	jmp    1012f0 <serial_putc+0x41>
        serial_putc_sub('\b');
  1012cc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012d3:	e8 79 ff ff ff       	call   101251 <serial_putc_sub>
        serial_putc_sub(' ');
  1012d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012df:	e8 6d ff ff ff       	call   101251 <serial_putc_sub>
        serial_putc_sub('\b');
  1012e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012eb:	e8 61 ff ff ff       	call   101251 <serial_putc_sub>
}
  1012f0:	90                   	nop
  1012f1:	c9                   	leave  
  1012f2:	c3                   	ret    

001012f3 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012f3:	f3 0f 1e fb          	endbr32 
  1012f7:	55                   	push   %ebp
  1012f8:	89 e5                	mov    %esp,%ebp
  1012fa:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012fd:	eb 33                	jmp    101332 <cons_intr+0x3f>
        if (c != 0) {
  1012ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101303:	74 2d                	je     101332 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  101305:	a1 84 00 11 00       	mov    0x110084,%eax
  10130a:	8d 50 01             	lea    0x1(%eax),%edx
  10130d:	89 15 84 00 11 00    	mov    %edx,0x110084
  101313:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101316:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10131c:	a1 84 00 11 00       	mov    0x110084,%eax
  101321:	3d 00 02 00 00       	cmp    $0x200,%eax
  101326:	75 0a                	jne    101332 <cons_intr+0x3f>
                cons.wpos = 0;
  101328:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  10132f:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101332:	8b 45 08             	mov    0x8(%ebp),%eax
  101335:	ff d0                	call   *%eax
  101337:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10133a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10133e:	75 bf                	jne    1012ff <cons_intr+0xc>
            }
        }
    }
}
  101340:	90                   	nop
  101341:	90                   	nop
  101342:	c9                   	leave  
  101343:	c3                   	ret    

00101344 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101344:	f3 0f 1e fb          	endbr32 
  101348:	55                   	push   %ebp
  101349:	89 e5                	mov    %esp,%ebp
  10134b:	83 ec 10             	sub    $0x10,%esp
  10134e:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101354:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101358:	89 c2                	mov    %eax,%edx
  10135a:	ec                   	in     (%dx),%al
  10135b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10135e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101362:	0f b6 c0             	movzbl %al,%eax
  101365:	83 e0 01             	and    $0x1,%eax
  101368:	85 c0                	test   %eax,%eax
  10136a:	75 07                	jne    101373 <serial_proc_data+0x2f>
        return -1;
  10136c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101371:	eb 2a                	jmp    10139d <serial_proc_data+0x59>
  101373:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101379:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10137d:	89 c2                	mov    %eax,%edx
  10137f:	ec                   	in     (%dx),%al
  101380:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101383:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101387:	0f b6 c0             	movzbl %al,%eax
  10138a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10138d:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101391:	75 07                	jne    10139a <serial_proc_data+0x56>
        c = '\b';
  101393:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10139a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10139d:	c9                   	leave  
  10139e:	c3                   	ret    

0010139f <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10139f:	f3 0f 1e fb          	endbr32 
  1013a3:	55                   	push   %ebp
  1013a4:	89 e5                	mov    %esp,%ebp
  1013a6:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013a9:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  1013ae:	85 c0                	test   %eax,%eax
  1013b0:	74 0c                	je     1013be <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1013b2:	c7 04 24 44 13 10 00 	movl   $0x101344,(%esp)
  1013b9:	e8 35 ff ff ff       	call   1012f3 <cons_intr>
    }
}
  1013be:	90                   	nop
  1013bf:	c9                   	leave  
  1013c0:	c3                   	ret    

001013c1 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013c1:	f3 0f 1e fb          	endbr32 
  1013c5:	55                   	push   %ebp
  1013c6:	89 e5                	mov    %esp,%ebp
  1013c8:	83 ec 38             	sub    $0x38,%esp
  1013cb:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1013d4:	89 c2                	mov    %eax,%edx
  1013d6:	ec                   	in     (%dx),%al
  1013d7:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013da:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013de:	0f b6 c0             	movzbl %al,%eax
  1013e1:	83 e0 01             	and    $0x1,%eax
  1013e4:	85 c0                	test   %eax,%eax
  1013e6:	75 0a                	jne    1013f2 <kbd_proc_data+0x31>
        return -1;
  1013e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013ed:	e9 56 01 00 00       	jmp    101548 <kbd_proc_data+0x187>
  1013f2:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1013fb:	89 c2                	mov    %eax,%edx
  1013fd:	ec                   	in     (%dx),%al
  1013fe:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101401:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101405:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101408:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10140c:	75 17                	jne    101425 <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  10140e:	a1 88 00 11 00       	mov    0x110088,%eax
  101413:	83 c8 40             	or     $0x40,%eax
  101416:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  10141b:	b8 00 00 00 00       	mov    $0x0,%eax
  101420:	e9 23 01 00 00       	jmp    101548 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101425:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101429:	84 c0                	test   %al,%al
  10142b:	79 45                	jns    101472 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10142d:	a1 88 00 11 00       	mov    0x110088,%eax
  101432:	83 e0 40             	and    $0x40,%eax
  101435:	85 c0                	test   %eax,%eax
  101437:	75 08                	jne    101441 <kbd_proc_data+0x80>
  101439:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10143d:	24 7f                	and    $0x7f,%al
  10143f:	eb 04                	jmp    101445 <kbd_proc_data+0x84>
  101441:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101445:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101448:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10144c:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  101453:	0c 40                	or     $0x40,%al
  101455:	0f b6 c0             	movzbl %al,%eax
  101458:	f7 d0                	not    %eax
  10145a:	89 c2                	mov    %eax,%edx
  10145c:	a1 88 00 11 00       	mov    0x110088,%eax
  101461:	21 d0                	and    %edx,%eax
  101463:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  101468:	b8 00 00 00 00       	mov    $0x0,%eax
  10146d:	e9 d6 00 00 00       	jmp    101548 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101472:	a1 88 00 11 00       	mov    0x110088,%eax
  101477:	83 e0 40             	and    $0x40,%eax
  10147a:	85 c0                	test   %eax,%eax
  10147c:	74 11                	je     10148f <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10147e:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101482:	a1 88 00 11 00       	mov    0x110088,%eax
  101487:	83 e0 bf             	and    $0xffffffbf,%eax
  10148a:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  10148f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101493:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  10149a:	0f b6 d0             	movzbl %al,%edx
  10149d:	a1 88 00 11 00       	mov    0x110088,%eax
  1014a2:	09 d0                	or     %edx,%eax
  1014a4:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  1014a9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ad:	0f b6 80 40 f1 10 00 	movzbl 0x10f140(%eax),%eax
  1014b4:	0f b6 d0             	movzbl %al,%edx
  1014b7:	a1 88 00 11 00       	mov    0x110088,%eax
  1014bc:	31 d0                	xor    %edx,%eax
  1014be:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014c3:	a1 88 00 11 00       	mov    0x110088,%eax
  1014c8:	83 e0 03             	and    $0x3,%eax
  1014cb:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  1014d2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d6:	01 d0                	add    %edx,%eax
  1014d8:	0f b6 00             	movzbl (%eax),%eax
  1014db:	0f b6 c0             	movzbl %al,%eax
  1014de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014e1:	a1 88 00 11 00       	mov    0x110088,%eax
  1014e6:	83 e0 08             	and    $0x8,%eax
  1014e9:	85 c0                	test   %eax,%eax
  1014eb:	74 22                	je     10150f <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014ed:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014f1:	7e 0c                	jle    1014ff <kbd_proc_data+0x13e>
  1014f3:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014f7:	7f 06                	jg     1014ff <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014f9:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014fd:	eb 10                	jmp    10150f <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014ff:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101503:	7e 0a                	jle    10150f <kbd_proc_data+0x14e>
  101505:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101509:	7f 04                	jg     10150f <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10150b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10150f:	a1 88 00 11 00       	mov    0x110088,%eax
  101514:	f7 d0                	not    %eax
  101516:	83 e0 06             	and    $0x6,%eax
  101519:	85 c0                	test   %eax,%eax
  10151b:	75 28                	jne    101545 <kbd_proc_data+0x184>
  10151d:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101524:	75 1f                	jne    101545 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101526:	c7 04 24 85 36 10 00 	movl   $0x103685,(%esp)
  10152d:	e8 52 ed ff ff       	call   100284 <cprintf>
  101532:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101538:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10153c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101540:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101543:	ee                   	out    %al,(%dx)
}
  101544:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101545:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101548:	c9                   	leave  
  101549:	c3                   	ret    

0010154a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10154a:	f3 0f 1e fb          	endbr32 
  10154e:	55                   	push   %ebp
  10154f:	89 e5                	mov    %esp,%ebp
  101551:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101554:	c7 04 24 c1 13 10 00 	movl   $0x1013c1,(%esp)
  10155b:	e8 93 fd ff ff       	call   1012f3 <cons_intr>
}
  101560:	90                   	nop
  101561:	c9                   	leave  
  101562:	c3                   	ret    

00101563 <kbd_init>:

static void
kbd_init(void) {
  101563:	f3 0f 1e fb          	endbr32 
  101567:	55                   	push   %ebp
  101568:	89 e5                	mov    %esp,%ebp
  10156a:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10156d:	e8 d8 ff ff ff       	call   10154a <kbd_intr>
    pic_enable(IRQ_KBD);
  101572:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101579:	e8 21 01 00 00       	call   10169f <pic_enable>
}
  10157e:	90                   	nop
  10157f:	c9                   	leave  
  101580:	c3                   	ret    

00101581 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101581:	f3 0f 1e fb          	endbr32 
  101585:	55                   	push   %ebp
  101586:	89 e5                	mov    %esp,%ebp
  101588:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10158b:	e8 2e f8 ff ff       	call   100dbe <cga_init>
    serial_init();
  101590:	e8 13 f9 ff ff       	call   100ea8 <serial_init>
    kbd_init();
  101595:	e8 c9 ff ff ff       	call   101563 <kbd_init>
    if (!serial_exists) {
  10159a:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  10159f:	85 c0                	test   %eax,%eax
  1015a1:	75 0c                	jne    1015af <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1015a3:	c7 04 24 91 36 10 00 	movl   $0x103691,(%esp)
  1015aa:	e8 d5 ec ff ff       	call   100284 <cprintf>
    }
}
  1015af:	90                   	nop
  1015b0:	c9                   	leave  
  1015b1:	c3                   	ret    

001015b2 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015b2:	f3 0f 1e fb          	endbr32 
  1015b6:	55                   	push   %ebp
  1015b7:	89 e5                	mov    %esp,%ebp
  1015b9:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1015bf:	89 04 24             	mov    %eax,(%esp)
  1015c2:	e8 50 fa ff ff       	call   101017 <lpt_putc>
    cga_putc(c);
  1015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1015ca:	89 04 24             	mov    %eax,(%esp)
  1015cd:	e8 89 fa ff ff       	call   10105b <cga_putc>
    serial_putc(c);
  1015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1015d5:	89 04 24             	mov    %eax,(%esp)
  1015d8:	e8 d2 fc ff ff       	call   1012af <serial_putc>
}
  1015dd:	90                   	nop
  1015de:	c9                   	leave  
  1015df:	c3                   	ret    

001015e0 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015e0:	f3 0f 1e fb          	endbr32 
  1015e4:	55                   	push   %ebp
  1015e5:	89 e5                	mov    %esp,%ebp
  1015e7:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015ea:	e8 b0 fd ff ff       	call   10139f <serial_intr>
    kbd_intr();
  1015ef:	e8 56 ff ff ff       	call   10154a <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015f4:	8b 15 80 00 11 00    	mov    0x110080,%edx
  1015fa:	a1 84 00 11 00       	mov    0x110084,%eax
  1015ff:	39 c2                	cmp    %eax,%edx
  101601:	74 36                	je     101639 <cons_getc+0x59>
        c = cons.buf[cons.rpos ++];
  101603:	a1 80 00 11 00       	mov    0x110080,%eax
  101608:	8d 50 01             	lea    0x1(%eax),%edx
  10160b:	89 15 80 00 11 00    	mov    %edx,0x110080
  101611:	0f b6 80 80 fe 10 00 	movzbl 0x10fe80(%eax),%eax
  101618:	0f b6 c0             	movzbl %al,%eax
  10161b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  10161e:	a1 80 00 11 00       	mov    0x110080,%eax
  101623:	3d 00 02 00 00       	cmp    $0x200,%eax
  101628:	75 0a                	jne    101634 <cons_getc+0x54>
            cons.rpos = 0;
  10162a:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  101631:	00 00 00 
        }
        return c;
  101634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101637:	eb 05                	jmp    10163e <cons_getc+0x5e>
    }
    return 0;
  101639:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10163e:	c9                   	leave  
  10163f:	c3                   	ret    

00101640 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101640:	f3 0f 1e fb          	endbr32 
  101644:	55                   	push   %ebp
  101645:	89 e5                	mov    %esp,%ebp
  101647:	83 ec 14             	sub    $0x14,%esp
  10164a:	8b 45 08             	mov    0x8(%ebp),%eax
  10164d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101651:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101654:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  10165a:	a1 8c 00 11 00       	mov    0x11008c,%eax
  10165f:	85 c0                	test   %eax,%eax
  101661:	74 39                	je     10169c <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  101663:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101666:	0f b6 c0             	movzbl %al,%eax
  101669:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  10166f:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101672:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101676:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10167a:	ee                   	out    %al,(%dx)
}
  10167b:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  10167c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101680:	c1 e8 08             	shr    $0x8,%eax
  101683:	0f b7 c0             	movzwl %ax,%eax
  101686:	0f b6 c0             	movzbl %al,%eax
  101689:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  10168f:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101692:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101696:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10169a:	ee                   	out    %al,(%dx)
}
  10169b:	90                   	nop
    }
}
  10169c:	90                   	nop
  10169d:	c9                   	leave  
  10169e:	c3                   	ret    

0010169f <pic_enable>:

void
pic_enable(unsigned int irq) {
  10169f:	f3 0f 1e fb          	endbr32 
  1016a3:	55                   	push   %ebp
  1016a4:	89 e5                	mov    %esp,%ebp
  1016a6:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1016ac:	ba 01 00 00 00       	mov    $0x1,%edx
  1016b1:	88 c1                	mov    %al,%cl
  1016b3:	d3 e2                	shl    %cl,%edx
  1016b5:	89 d0                	mov    %edx,%eax
  1016b7:	98                   	cwtl   
  1016b8:	f7 d0                	not    %eax
  1016ba:	0f bf d0             	movswl %ax,%edx
  1016bd:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  1016c4:	98                   	cwtl   
  1016c5:	21 d0                	and    %edx,%eax
  1016c7:	98                   	cwtl   
  1016c8:	0f b7 c0             	movzwl %ax,%eax
  1016cb:	89 04 24             	mov    %eax,(%esp)
  1016ce:	e8 6d ff ff ff       	call   101640 <pic_setmask>
}
  1016d3:	90                   	nop
  1016d4:	c9                   	leave  
  1016d5:	c3                   	ret    

001016d6 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016d6:	f3 0f 1e fb          	endbr32 
  1016da:	55                   	push   %ebp
  1016db:	89 e5                	mov    %esp,%ebp
  1016dd:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016e0:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  1016e7:	00 00 00 
  1016ea:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1016f0:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016f4:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1016f8:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1016fc:	ee                   	out    %al,(%dx)
}
  1016fd:	90                   	nop
  1016fe:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101704:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101708:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10170c:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101710:	ee                   	out    %al,(%dx)
}
  101711:	90                   	nop
  101712:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101718:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10171c:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101720:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101724:	ee                   	out    %al,(%dx)
}
  101725:	90                   	nop
  101726:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10172c:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101730:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101734:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101738:	ee                   	out    %al,(%dx)
}
  101739:	90                   	nop
  10173a:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101740:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101744:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101748:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10174c:	ee                   	out    %al,(%dx)
}
  10174d:	90                   	nop
  10174e:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101754:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101758:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10175c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101760:	ee                   	out    %al,(%dx)
}
  101761:	90                   	nop
  101762:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101768:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10176c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101770:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101774:	ee                   	out    %al,(%dx)
}
  101775:	90                   	nop
  101776:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  10177c:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101780:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101784:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101788:	ee                   	out    %al,(%dx)
}
  101789:	90                   	nop
  10178a:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101790:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101794:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101798:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10179c:	ee                   	out    %al,(%dx)
}
  10179d:	90                   	nop
  10179e:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1017a4:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017a8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017ac:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017b0:	ee                   	out    %al,(%dx)
}
  1017b1:	90                   	nop
  1017b2:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1017b8:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017bc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1017c0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017c4:	ee                   	out    %al,(%dx)
}
  1017c5:	90                   	nop
  1017c6:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1017cc:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017d0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1017d4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1017d8:	ee                   	out    %al,(%dx)
}
  1017d9:	90                   	nop
  1017da:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1017e0:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017e4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017e8:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017ec:	ee                   	out    %al,(%dx)
}
  1017ed:	90                   	nop
  1017ee:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1017f4:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017f8:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017fc:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101800:	ee                   	out    %al,(%dx)
}
  101801:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101802:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  101809:	3d ff ff 00 00       	cmp    $0xffff,%eax
  10180e:	74 0f                	je     10181f <pic_init+0x149>
        pic_setmask(irq_mask);
  101810:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  101817:	89 04 24             	mov    %eax,(%esp)
  10181a:	e8 21 fe ff ff       	call   101640 <pic_setmask>
    }
}
  10181f:	90                   	nop
  101820:	c9                   	leave  
  101821:	c3                   	ret    

00101822 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101822:	f3 0f 1e fb          	endbr32 
  101826:	55                   	push   %ebp
  101827:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101829:	fb                   	sti    
}
  10182a:	90                   	nop
    sti();
}
  10182b:	90                   	nop
  10182c:	5d                   	pop    %ebp
  10182d:	c3                   	ret    

0010182e <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10182e:	f3 0f 1e fb          	endbr32 
  101832:	55                   	push   %ebp
  101833:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  101835:	fa                   	cli    
}
  101836:	90                   	nop
    cli();
}
  101837:	90                   	nop
  101838:	5d                   	pop    %ebp
  101839:	c3                   	ret    

0010183a <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10183a:	f3 0f 1e fb          	endbr32 
  10183e:	55                   	push   %ebp
  10183f:	89 e5                	mov    %esp,%ebp
  101841:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101844:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10184b:	00 
  10184c:	c7 04 24 c0 36 10 00 	movl   $0x1036c0,(%esp)
  101853:	e8 2c ea ff ff       	call   100284 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101858:	90                   	nop
  101859:	c9                   	leave  
  10185a:	c3                   	ret    

0010185b <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10185b:	f3 0f 1e fb          	endbr32 
  10185f:	55                   	push   %ebp
  101860:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  101862:	90                   	nop
  101863:	5d                   	pop    %ebp
  101864:	c3                   	ret    

00101865 <trapname>:

static const char *
trapname(int trapno) {
  101865:	f3 0f 1e fb          	endbr32 
  101869:	55                   	push   %ebp
  10186a:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  10186c:	8b 45 08             	mov    0x8(%ebp),%eax
  10186f:	83 f8 13             	cmp    $0x13,%eax
  101872:	77 0c                	ja     101880 <trapname+0x1b>
        return excnames[trapno];
  101874:	8b 45 08             	mov    0x8(%ebp),%eax
  101877:	8b 04 85 20 3a 10 00 	mov    0x103a20(,%eax,4),%eax
  10187e:	eb 18                	jmp    101898 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101880:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101884:	7e 0d                	jle    101893 <trapname+0x2e>
  101886:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  10188a:	7f 07                	jg     101893 <trapname+0x2e>
        return "Hardware Interrupt";
  10188c:	b8 ca 36 10 00       	mov    $0x1036ca,%eax
  101891:	eb 05                	jmp    101898 <trapname+0x33>
    }
    return "(unknown trap)";
  101893:	b8 dd 36 10 00       	mov    $0x1036dd,%eax
}
  101898:	5d                   	pop    %ebp
  101899:	c3                   	ret    

0010189a <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  10189a:	f3 0f 1e fb          	endbr32 
  10189e:	55                   	push   %ebp
  10189f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1018a4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1018a8:	83 f8 08             	cmp    $0x8,%eax
  1018ab:	0f 94 c0             	sete   %al
  1018ae:	0f b6 c0             	movzbl %al,%eax
}
  1018b1:	5d                   	pop    %ebp
  1018b2:	c3                   	ret    

001018b3 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1018b3:	f3 0f 1e fb          	endbr32 
  1018b7:	55                   	push   %ebp
  1018b8:	89 e5                	mov    %esp,%ebp
  1018ba:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1018c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018c4:	c7 04 24 1e 37 10 00 	movl   $0x10371e,(%esp)
  1018cb:	e8 b4 e9 ff ff       	call   100284 <cprintf>
    print_regs(&tf->tf_regs);
  1018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1018d3:	89 04 24             	mov    %eax,(%esp)
  1018d6:	e8 8d 01 00 00       	call   101a68 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1018db:	8b 45 08             	mov    0x8(%ebp),%eax
  1018de:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1018e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018e6:	c7 04 24 2f 37 10 00 	movl   $0x10372f,(%esp)
  1018ed:	e8 92 e9 ff ff       	call   100284 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1018f5:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1018f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018fd:	c7 04 24 42 37 10 00 	movl   $0x103742,(%esp)
  101904:	e8 7b e9 ff ff       	call   100284 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101909:	8b 45 08             	mov    0x8(%ebp),%eax
  10190c:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101910:	89 44 24 04          	mov    %eax,0x4(%esp)
  101914:	c7 04 24 55 37 10 00 	movl   $0x103755,(%esp)
  10191b:	e8 64 e9 ff ff       	call   100284 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101920:	8b 45 08             	mov    0x8(%ebp),%eax
  101923:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101927:	89 44 24 04          	mov    %eax,0x4(%esp)
  10192b:	c7 04 24 68 37 10 00 	movl   $0x103768,(%esp)
  101932:	e8 4d e9 ff ff       	call   100284 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101937:	8b 45 08             	mov    0x8(%ebp),%eax
  10193a:	8b 40 30             	mov    0x30(%eax),%eax
  10193d:	89 04 24             	mov    %eax,(%esp)
  101940:	e8 20 ff ff ff       	call   101865 <trapname>
  101945:	8b 55 08             	mov    0x8(%ebp),%edx
  101948:	8b 52 30             	mov    0x30(%edx),%edx
  10194b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10194f:	89 54 24 04          	mov    %edx,0x4(%esp)
  101953:	c7 04 24 7b 37 10 00 	movl   $0x10377b,(%esp)
  10195a:	e8 25 e9 ff ff       	call   100284 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  10195f:	8b 45 08             	mov    0x8(%ebp),%eax
  101962:	8b 40 34             	mov    0x34(%eax),%eax
  101965:	89 44 24 04          	mov    %eax,0x4(%esp)
  101969:	c7 04 24 8d 37 10 00 	movl   $0x10378d,(%esp)
  101970:	e8 0f e9 ff ff       	call   100284 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101975:	8b 45 08             	mov    0x8(%ebp),%eax
  101978:	8b 40 38             	mov    0x38(%eax),%eax
  10197b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10197f:	c7 04 24 9c 37 10 00 	movl   $0x10379c,(%esp)
  101986:	e8 f9 e8 ff ff       	call   100284 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  10198b:	8b 45 08             	mov    0x8(%ebp),%eax
  10198e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101992:	89 44 24 04          	mov    %eax,0x4(%esp)
  101996:	c7 04 24 ab 37 10 00 	movl   $0x1037ab,(%esp)
  10199d:	e8 e2 e8 ff ff       	call   100284 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  1019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a5:	8b 40 40             	mov    0x40(%eax),%eax
  1019a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019ac:	c7 04 24 be 37 10 00 	movl   $0x1037be,(%esp)
  1019b3:	e8 cc e8 ff ff       	call   100284 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  1019b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1019bf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  1019c6:	eb 3d                	jmp    101a05 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  1019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019cb:	8b 50 40             	mov    0x40(%eax),%edx
  1019ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1019d1:	21 d0                	and    %edx,%eax
  1019d3:	85 c0                	test   %eax,%eax
  1019d5:	74 28                	je     1019ff <print_trapframe+0x14c>
  1019d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019da:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  1019e1:	85 c0                	test   %eax,%eax
  1019e3:	74 1a                	je     1019ff <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  1019e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019e8:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  1019ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019f3:	c7 04 24 cd 37 10 00 	movl   $0x1037cd,(%esp)
  1019fa:	e8 85 e8 ff ff       	call   100284 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  1019ff:	ff 45 f4             	incl   -0xc(%ebp)
  101a02:	d1 65 f0             	shll   -0x10(%ebp)
  101a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a08:	83 f8 17             	cmp    $0x17,%eax
  101a0b:	76 bb                	jbe    1019c8 <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a10:	8b 40 40             	mov    0x40(%eax),%eax
  101a13:	c1 e8 0c             	shr    $0xc,%eax
  101a16:	83 e0 03             	and    $0x3,%eax
  101a19:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a1d:	c7 04 24 d1 37 10 00 	movl   $0x1037d1,(%esp)
  101a24:	e8 5b e8 ff ff       	call   100284 <cprintf>

    if (!trap_in_kernel(tf)) {
  101a29:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2c:	89 04 24             	mov    %eax,(%esp)
  101a2f:	e8 66 fe ff ff       	call   10189a <trap_in_kernel>
  101a34:	85 c0                	test   %eax,%eax
  101a36:	75 2d                	jne    101a65 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101a38:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3b:	8b 40 44             	mov    0x44(%eax),%eax
  101a3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a42:	c7 04 24 da 37 10 00 	movl   $0x1037da,(%esp)
  101a49:	e8 36 e8 ff ff       	call   100284 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a51:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101a55:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a59:	c7 04 24 e9 37 10 00 	movl   $0x1037e9,(%esp)
  101a60:	e8 1f e8 ff ff       	call   100284 <cprintf>
    }
}
  101a65:	90                   	nop
  101a66:	c9                   	leave  
  101a67:	c3                   	ret    

00101a68 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101a68:	f3 0f 1e fb          	endbr32 
  101a6c:	55                   	push   %ebp
  101a6d:	89 e5                	mov    %esp,%ebp
  101a6f:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101a72:	8b 45 08             	mov    0x8(%ebp),%eax
  101a75:	8b 00                	mov    (%eax),%eax
  101a77:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a7b:	c7 04 24 fc 37 10 00 	movl   $0x1037fc,(%esp)
  101a82:	e8 fd e7 ff ff       	call   100284 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101a87:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8a:	8b 40 04             	mov    0x4(%eax),%eax
  101a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a91:	c7 04 24 0b 38 10 00 	movl   $0x10380b,(%esp)
  101a98:	e8 e7 e7 ff ff       	call   100284 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa0:	8b 40 08             	mov    0x8(%eax),%eax
  101aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa7:	c7 04 24 1a 38 10 00 	movl   $0x10381a,(%esp)
  101aae:	e8 d1 e7 ff ff       	call   100284 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab6:	8b 40 0c             	mov    0xc(%eax),%eax
  101ab9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101abd:	c7 04 24 29 38 10 00 	movl   $0x103829,(%esp)
  101ac4:	e8 bb e7 ff ff       	call   100284 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  101acc:	8b 40 10             	mov    0x10(%eax),%eax
  101acf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad3:	c7 04 24 38 38 10 00 	movl   $0x103838,(%esp)
  101ada:	e8 a5 e7 ff ff       	call   100284 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101adf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae2:	8b 40 14             	mov    0x14(%eax),%eax
  101ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae9:	c7 04 24 47 38 10 00 	movl   $0x103847,(%esp)
  101af0:	e8 8f e7 ff ff       	call   100284 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101af5:	8b 45 08             	mov    0x8(%ebp),%eax
  101af8:	8b 40 18             	mov    0x18(%eax),%eax
  101afb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aff:	c7 04 24 56 38 10 00 	movl   $0x103856,(%esp)
  101b06:	e8 79 e7 ff ff       	call   100284 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0e:	8b 40 1c             	mov    0x1c(%eax),%eax
  101b11:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b15:	c7 04 24 65 38 10 00 	movl   $0x103865,(%esp)
  101b1c:	e8 63 e7 ff ff       	call   100284 <cprintf>
}
  101b21:	90                   	nop
  101b22:	c9                   	leave  
  101b23:	c3                   	ret    

00101b24 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101b24:	f3 0f 1e fb          	endbr32 
  101b28:	55                   	push   %ebp
  101b29:	89 e5                	mov    %esp,%ebp
  101b2b:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b31:	8b 40 30             	mov    0x30(%eax),%eax
  101b34:	83 f8 79             	cmp    $0x79,%eax
  101b37:	0f 87 99 00 00 00    	ja     101bd6 <trap_dispatch+0xb2>
  101b3d:	83 f8 78             	cmp    $0x78,%eax
  101b40:	73 78                	jae    101bba <trap_dispatch+0x96>
  101b42:	83 f8 2f             	cmp    $0x2f,%eax
  101b45:	0f 87 8b 00 00 00    	ja     101bd6 <trap_dispatch+0xb2>
  101b4b:	83 f8 2e             	cmp    $0x2e,%eax
  101b4e:	0f 83 b7 00 00 00    	jae    101c0b <trap_dispatch+0xe7>
  101b54:	83 f8 24             	cmp    $0x24,%eax
  101b57:	74 15                	je     101b6e <trap_dispatch+0x4a>
  101b59:	83 f8 24             	cmp    $0x24,%eax
  101b5c:	77 78                	ja     101bd6 <trap_dispatch+0xb2>
  101b5e:	83 f8 20             	cmp    $0x20,%eax
  101b61:	0f 84 a7 00 00 00    	je     101c0e <trap_dispatch+0xea>
  101b67:	83 f8 21             	cmp    $0x21,%eax
  101b6a:	74 28                	je     101b94 <trap_dispatch+0x70>
  101b6c:	eb 68                	jmp    101bd6 <trap_dispatch+0xb2>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101b6e:	e8 6d fa ff ff       	call   1015e0 <cons_getc>
  101b73:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101b76:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101b7a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101b7e:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b82:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b86:	c7 04 24 74 38 10 00 	movl   $0x103874,(%esp)
  101b8d:	e8 f2 e6 ff ff       	call   100284 <cprintf>
        break;
  101b92:	eb 7b                	jmp    101c0f <trap_dispatch+0xeb>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101b94:	e8 47 fa ff ff       	call   1015e0 <cons_getc>
  101b99:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101b9c:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ba0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ba4:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bac:	c7 04 24 86 38 10 00 	movl   $0x103886,(%esp)
  101bb3:	e8 cc e6 ff ff       	call   100284 <cprintf>
        break;
  101bb8:	eb 55                	jmp    101c0f <trap_dispatch+0xeb>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101bba:	c7 44 24 08 95 38 10 	movl   $0x103895,0x8(%esp)
  101bc1:	00 
  101bc2:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  101bc9:	00 
  101bca:	c7 04 24 a5 38 10 00 	movl   $0x1038a5,(%esp)
  101bd1:	e8 1a e8 ff ff       	call   1003f0 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bdd:	83 e0 03             	and    $0x3,%eax
  101be0:	85 c0                	test   %eax,%eax
  101be2:	75 2b                	jne    101c0f <trap_dispatch+0xeb>
            print_trapframe(tf);
  101be4:	8b 45 08             	mov    0x8(%ebp),%eax
  101be7:	89 04 24             	mov    %eax,(%esp)
  101bea:	e8 c4 fc ff ff       	call   1018b3 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101bef:	c7 44 24 08 b6 38 10 	movl   $0x1038b6,0x8(%esp)
  101bf6:	00 
  101bf7:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  101bfe:	00 
  101bff:	c7 04 24 a5 38 10 00 	movl   $0x1038a5,(%esp)
  101c06:	e8 e5 e7 ff ff       	call   1003f0 <__panic>
        break;
  101c0b:	90                   	nop
  101c0c:	eb 01                	jmp    101c0f <trap_dispatch+0xeb>
        break;
  101c0e:	90                   	nop
        }
    }
}
  101c0f:	90                   	nop
  101c10:	c9                   	leave  
  101c11:	c3                   	ret    

00101c12 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101c12:	f3 0f 1e fb          	endbr32 
  101c16:	55                   	push   %ebp
  101c17:	89 e5                	mov    %esp,%ebp
  101c19:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1f:	89 04 24             	mov    %eax,(%esp)
  101c22:	e8 fd fe ff ff       	call   101b24 <trap_dispatch>
}
  101c27:	90                   	nop
  101c28:	c9                   	leave  
  101c29:	c3                   	ret    

00101c2a <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101c2a:	6a 00                	push   $0x0
  pushl $0
  101c2c:	6a 00                	push   $0x0
  jmp __alltraps
  101c2e:	e9 69 0a 00 00       	jmp    10269c <__alltraps>

00101c33 <vector1>:
.globl vector1
vector1:
  pushl $0
  101c33:	6a 00                	push   $0x0
  pushl $1
  101c35:	6a 01                	push   $0x1
  jmp __alltraps
  101c37:	e9 60 0a 00 00       	jmp    10269c <__alltraps>

00101c3c <vector2>:
.globl vector2
vector2:
  pushl $0
  101c3c:	6a 00                	push   $0x0
  pushl $2
  101c3e:	6a 02                	push   $0x2
  jmp __alltraps
  101c40:	e9 57 0a 00 00       	jmp    10269c <__alltraps>

00101c45 <vector3>:
.globl vector3
vector3:
  pushl $0
  101c45:	6a 00                	push   $0x0
  pushl $3
  101c47:	6a 03                	push   $0x3
  jmp __alltraps
  101c49:	e9 4e 0a 00 00       	jmp    10269c <__alltraps>

00101c4e <vector4>:
.globl vector4
vector4:
  pushl $0
  101c4e:	6a 00                	push   $0x0
  pushl $4
  101c50:	6a 04                	push   $0x4
  jmp __alltraps
  101c52:	e9 45 0a 00 00       	jmp    10269c <__alltraps>

00101c57 <vector5>:
.globl vector5
vector5:
  pushl $0
  101c57:	6a 00                	push   $0x0
  pushl $5
  101c59:	6a 05                	push   $0x5
  jmp __alltraps
  101c5b:	e9 3c 0a 00 00       	jmp    10269c <__alltraps>

00101c60 <vector6>:
.globl vector6
vector6:
  pushl $0
  101c60:	6a 00                	push   $0x0
  pushl $6
  101c62:	6a 06                	push   $0x6
  jmp __alltraps
  101c64:	e9 33 0a 00 00       	jmp    10269c <__alltraps>

00101c69 <vector7>:
.globl vector7
vector7:
  pushl $0
  101c69:	6a 00                	push   $0x0
  pushl $7
  101c6b:	6a 07                	push   $0x7
  jmp __alltraps
  101c6d:	e9 2a 0a 00 00       	jmp    10269c <__alltraps>

00101c72 <vector8>:
.globl vector8
vector8:
  pushl $8
  101c72:	6a 08                	push   $0x8
  jmp __alltraps
  101c74:	e9 23 0a 00 00       	jmp    10269c <__alltraps>

00101c79 <vector9>:
.globl vector9
vector9:
  pushl $0
  101c79:	6a 00                	push   $0x0
  pushl $9
  101c7b:	6a 09                	push   $0x9
  jmp __alltraps
  101c7d:	e9 1a 0a 00 00       	jmp    10269c <__alltraps>

00101c82 <vector10>:
.globl vector10
vector10:
  pushl $10
  101c82:	6a 0a                	push   $0xa
  jmp __alltraps
  101c84:	e9 13 0a 00 00       	jmp    10269c <__alltraps>

00101c89 <vector11>:
.globl vector11
vector11:
  pushl $11
  101c89:	6a 0b                	push   $0xb
  jmp __alltraps
  101c8b:	e9 0c 0a 00 00       	jmp    10269c <__alltraps>

00101c90 <vector12>:
.globl vector12
vector12:
  pushl $12
  101c90:	6a 0c                	push   $0xc
  jmp __alltraps
  101c92:	e9 05 0a 00 00       	jmp    10269c <__alltraps>

00101c97 <vector13>:
.globl vector13
vector13:
  pushl $13
  101c97:	6a 0d                	push   $0xd
  jmp __alltraps
  101c99:	e9 fe 09 00 00       	jmp    10269c <__alltraps>

00101c9e <vector14>:
.globl vector14
vector14:
  pushl $14
  101c9e:	6a 0e                	push   $0xe
  jmp __alltraps
  101ca0:	e9 f7 09 00 00       	jmp    10269c <__alltraps>

00101ca5 <vector15>:
.globl vector15
vector15:
  pushl $0
  101ca5:	6a 00                	push   $0x0
  pushl $15
  101ca7:	6a 0f                	push   $0xf
  jmp __alltraps
  101ca9:	e9 ee 09 00 00       	jmp    10269c <__alltraps>

00101cae <vector16>:
.globl vector16
vector16:
  pushl $0
  101cae:	6a 00                	push   $0x0
  pushl $16
  101cb0:	6a 10                	push   $0x10
  jmp __alltraps
  101cb2:	e9 e5 09 00 00       	jmp    10269c <__alltraps>

00101cb7 <vector17>:
.globl vector17
vector17:
  pushl $17
  101cb7:	6a 11                	push   $0x11
  jmp __alltraps
  101cb9:	e9 de 09 00 00       	jmp    10269c <__alltraps>

00101cbe <vector18>:
.globl vector18
vector18:
  pushl $0
  101cbe:	6a 00                	push   $0x0
  pushl $18
  101cc0:	6a 12                	push   $0x12
  jmp __alltraps
  101cc2:	e9 d5 09 00 00       	jmp    10269c <__alltraps>

00101cc7 <vector19>:
.globl vector19
vector19:
  pushl $0
  101cc7:	6a 00                	push   $0x0
  pushl $19
  101cc9:	6a 13                	push   $0x13
  jmp __alltraps
  101ccb:	e9 cc 09 00 00       	jmp    10269c <__alltraps>

00101cd0 <vector20>:
.globl vector20
vector20:
  pushl $0
  101cd0:	6a 00                	push   $0x0
  pushl $20
  101cd2:	6a 14                	push   $0x14
  jmp __alltraps
  101cd4:	e9 c3 09 00 00       	jmp    10269c <__alltraps>

00101cd9 <vector21>:
.globl vector21
vector21:
  pushl $0
  101cd9:	6a 00                	push   $0x0
  pushl $21
  101cdb:	6a 15                	push   $0x15
  jmp __alltraps
  101cdd:	e9 ba 09 00 00       	jmp    10269c <__alltraps>

00101ce2 <vector22>:
.globl vector22
vector22:
  pushl $0
  101ce2:	6a 00                	push   $0x0
  pushl $22
  101ce4:	6a 16                	push   $0x16
  jmp __alltraps
  101ce6:	e9 b1 09 00 00       	jmp    10269c <__alltraps>

00101ceb <vector23>:
.globl vector23
vector23:
  pushl $0
  101ceb:	6a 00                	push   $0x0
  pushl $23
  101ced:	6a 17                	push   $0x17
  jmp __alltraps
  101cef:	e9 a8 09 00 00       	jmp    10269c <__alltraps>

00101cf4 <vector24>:
.globl vector24
vector24:
  pushl $0
  101cf4:	6a 00                	push   $0x0
  pushl $24
  101cf6:	6a 18                	push   $0x18
  jmp __alltraps
  101cf8:	e9 9f 09 00 00       	jmp    10269c <__alltraps>

00101cfd <vector25>:
.globl vector25
vector25:
  pushl $0
  101cfd:	6a 00                	push   $0x0
  pushl $25
  101cff:	6a 19                	push   $0x19
  jmp __alltraps
  101d01:	e9 96 09 00 00       	jmp    10269c <__alltraps>

00101d06 <vector26>:
.globl vector26
vector26:
  pushl $0
  101d06:	6a 00                	push   $0x0
  pushl $26
  101d08:	6a 1a                	push   $0x1a
  jmp __alltraps
  101d0a:	e9 8d 09 00 00       	jmp    10269c <__alltraps>

00101d0f <vector27>:
.globl vector27
vector27:
  pushl $0
  101d0f:	6a 00                	push   $0x0
  pushl $27
  101d11:	6a 1b                	push   $0x1b
  jmp __alltraps
  101d13:	e9 84 09 00 00       	jmp    10269c <__alltraps>

00101d18 <vector28>:
.globl vector28
vector28:
  pushl $0
  101d18:	6a 00                	push   $0x0
  pushl $28
  101d1a:	6a 1c                	push   $0x1c
  jmp __alltraps
  101d1c:	e9 7b 09 00 00       	jmp    10269c <__alltraps>

00101d21 <vector29>:
.globl vector29
vector29:
  pushl $0
  101d21:	6a 00                	push   $0x0
  pushl $29
  101d23:	6a 1d                	push   $0x1d
  jmp __alltraps
  101d25:	e9 72 09 00 00       	jmp    10269c <__alltraps>

00101d2a <vector30>:
.globl vector30
vector30:
  pushl $0
  101d2a:	6a 00                	push   $0x0
  pushl $30
  101d2c:	6a 1e                	push   $0x1e
  jmp __alltraps
  101d2e:	e9 69 09 00 00       	jmp    10269c <__alltraps>

00101d33 <vector31>:
.globl vector31
vector31:
  pushl $0
  101d33:	6a 00                	push   $0x0
  pushl $31
  101d35:	6a 1f                	push   $0x1f
  jmp __alltraps
  101d37:	e9 60 09 00 00       	jmp    10269c <__alltraps>

00101d3c <vector32>:
.globl vector32
vector32:
  pushl $0
  101d3c:	6a 00                	push   $0x0
  pushl $32
  101d3e:	6a 20                	push   $0x20
  jmp __alltraps
  101d40:	e9 57 09 00 00       	jmp    10269c <__alltraps>

00101d45 <vector33>:
.globl vector33
vector33:
  pushl $0
  101d45:	6a 00                	push   $0x0
  pushl $33
  101d47:	6a 21                	push   $0x21
  jmp __alltraps
  101d49:	e9 4e 09 00 00       	jmp    10269c <__alltraps>

00101d4e <vector34>:
.globl vector34
vector34:
  pushl $0
  101d4e:	6a 00                	push   $0x0
  pushl $34
  101d50:	6a 22                	push   $0x22
  jmp __alltraps
  101d52:	e9 45 09 00 00       	jmp    10269c <__alltraps>

00101d57 <vector35>:
.globl vector35
vector35:
  pushl $0
  101d57:	6a 00                	push   $0x0
  pushl $35
  101d59:	6a 23                	push   $0x23
  jmp __alltraps
  101d5b:	e9 3c 09 00 00       	jmp    10269c <__alltraps>

00101d60 <vector36>:
.globl vector36
vector36:
  pushl $0
  101d60:	6a 00                	push   $0x0
  pushl $36
  101d62:	6a 24                	push   $0x24
  jmp __alltraps
  101d64:	e9 33 09 00 00       	jmp    10269c <__alltraps>

00101d69 <vector37>:
.globl vector37
vector37:
  pushl $0
  101d69:	6a 00                	push   $0x0
  pushl $37
  101d6b:	6a 25                	push   $0x25
  jmp __alltraps
  101d6d:	e9 2a 09 00 00       	jmp    10269c <__alltraps>

00101d72 <vector38>:
.globl vector38
vector38:
  pushl $0
  101d72:	6a 00                	push   $0x0
  pushl $38
  101d74:	6a 26                	push   $0x26
  jmp __alltraps
  101d76:	e9 21 09 00 00       	jmp    10269c <__alltraps>

00101d7b <vector39>:
.globl vector39
vector39:
  pushl $0
  101d7b:	6a 00                	push   $0x0
  pushl $39
  101d7d:	6a 27                	push   $0x27
  jmp __alltraps
  101d7f:	e9 18 09 00 00       	jmp    10269c <__alltraps>

00101d84 <vector40>:
.globl vector40
vector40:
  pushl $0
  101d84:	6a 00                	push   $0x0
  pushl $40
  101d86:	6a 28                	push   $0x28
  jmp __alltraps
  101d88:	e9 0f 09 00 00       	jmp    10269c <__alltraps>

00101d8d <vector41>:
.globl vector41
vector41:
  pushl $0
  101d8d:	6a 00                	push   $0x0
  pushl $41
  101d8f:	6a 29                	push   $0x29
  jmp __alltraps
  101d91:	e9 06 09 00 00       	jmp    10269c <__alltraps>

00101d96 <vector42>:
.globl vector42
vector42:
  pushl $0
  101d96:	6a 00                	push   $0x0
  pushl $42
  101d98:	6a 2a                	push   $0x2a
  jmp __alltraps
  101d9a:	e9 fd 08 00 00       	jmp    10269c <__alltraps>

00101d9f <vector43>:
.globl vector43
vector43:
  pushl $0
  101d9f:	6a 00                	push   $0x0
  pushl $43
  101da1:	6a 2b                	push   $0x2b
  jmp __alltraps
  101da3:	e9 f4 08 00 00       	jmp    10269c <__alltraps>

00101da8 <vector44>:
.globl vector44
vector44:
  pushl $0
  101da8:	6a 00                	push   $0x0
  pushl $44
  101daa:	6a 2c                	push   $0x2c
  jmp __alltraps
  101dac:	e9 eb 08 00 00       	jmp    10269c <__alltraps>

00101db1 <vector45>:
.globl vector45
vector45:
  pushl $0
  101db1:	6a 00                	push   $0x0
  pushl $45
  101db3:	6a 2d                	push   $0x2d
  jmp __alltraps
  101db5:	e9 e2 08 00 00       	jmp    10269c <__alltraps>

00101dba <vector46>:
.globl vector46
vector46:
  pushl $0
  101dba:	6a 00                	push   $0x0
  pushl $46
  101dbc:	6a 2e                	push   $0x2e
  jmp __alltraps
  101dbe:	e9 d9 08 00 00       	jmp    10269c <__alltraps>

00101dc3 <vector47>:
.globl vector47
vector47:
  pushl $0
  101dc3:	6a 00                	push   $0x0
  pushl $47
  101dc5:	6a 2f                	push   $0x2f
  jmp __alltraps
  101dc7:	e9 d0 08 00 00       	jmp    10269c <__alltraps>

00101dcc <vector48>:
.globl vector48
vector48:
  pushl $0
  101dcc:	6a 00                	push   $0x0
  pushl $48
  101dce:	6a 30                	push   $0x30
  jmp __alltraps
  101dd0:	e9 c7 08 00 00       	jmp    10269c <__alltraps>

00101dd5 <vector49>:
.globl vector49
vector49:
  pushl $0
  101dd5:	6a 00                	push   $0x0
  pushl $49
  101dd7:	6a 31                	push   $0x31
  jmp __alltraps
  101dd9:	e9 be 08 00 00       	jmp    10269c <__alltraps>

00101dde <vector50>:
.globl vector50
vector50:
  pushl $0
  101dde:	6a 00                	push   $0x0
  pushl $50
  101de0:	6a 32                	push   $0x32
  jmp __alltraps
  101de2:	e9 b5 08 00 00       	jmp    10269c <__alltraps>

00101de7 <vector51>:
.globl vector51
vector51:
  pushl $0
  101de7:	6a 00                	push   $0x0
  pushl $51
  101de9:	6a 33                	push   $0x33
  jmp __alltraps
  101deb:	e9 ac 08 00 00       	jmp    10269c <__alltraps>

00101df0 <vector52>:
.globl vector52
vector52:
  pushl $0
  101df0:	6a 00                	push   $0x0
  pushl $52
  101df2:	6a 34                	push   $0x34
  jmp __alltraps
  101df4:	e9 a3 08 00 00       	jmp    10269c <__alltraps>

00101df9 <vector53>:
.globl vector53
vector53:
  pushl $0
  101df9:	6a 00                	push   $0x0
  pushl $53
  101dfb:	6a 35                	push   $0x35
  jmp __alltraps
  101dfd:	e9 9a 08 00 00       	jmp    10269c <__alltraps>

00101e02 <vector54>:
.globl vector54
vector54:
  pushl $0
  101e02:	6a 00                	push   $0x0
  pushl $54
  101e04:	6a 36                	push   $0x36
  jmp __alltraps
  101e06:	e9 91 08 00 00       	jmp    10269c <__alltraps>

00101e0b <vector55>:
.globl vector55
vector55:
  pushl $0
  101e0b:	6a 00                	push   $0x0
  pushl $55
  101e0d:	6a 37                	push   $0x37
  jmp __alltraps
  101e0f:	e9 88 08 00 00       	jmp    10269c <__alltraps>

00101e14 <vector56>:
.globl vector56
vector56:
  pushl $0
  101e14:	6a 00                	push   $0x0
  pushl $56
  101e16:	6a 38                	push   $0x38
  jmp __alltraps
  101e18:	e9 7f 08 00 00       	jmp    10269c <__alltraps>

00101e1d <vector57>:
.globl vector57
vector57:
  pushl $0
  101e1d:	6a 00                	push   $0x0
  pushl $57
  101e1f:	6a 39                	push   $0x39
  jmp __alltraps
  101e21:	e9 76 08 00 00       	jmp    10269c <__alltraps>

00101e26 <vector58>:
.globl vector58
vector58:
  pushl $0
  101e26:	6a 00                	push   $0x0
  pushl $58
  101e28:	6a 3a                	push   $0x3a
  jmp __alltraps
  101e2a:	e9 6d 08 00 00       	jmp    10269c <__alltraps>

00101e2f <vector59>:
.globl vector59
vector59:
  pushl $0
  101e2f:	6a 00                	push   $0x0
  pushl $59
  101e31:	6a 3b                	push   $0x3b
  jmp __alltraps
  101e33:	e9 64 08 00 00       	jmp    10269c <__alltraps>

00101e38 <vector60>:
.globl vector60
vector60:
  pushl $0
  101e38:	6a 00                	push   $0x0
  pushl $60
  101e3a:	6a 3c                	push   $0x3c
  jmp __alltraps
  101e3c:	e9 5b 08 00 00       	jmp    10269c <__alltraps>

00101e41 <vector61>:
.globl vector61
vector61:
  pushl $0
  101e41:	6a 00                	push   $0x0
  pushl $61
  101e43:	6a 3d                	push   $0x3d
  jmp __alltraps
  101e45:	e9 52 08 00 00       	jmp    10269c <__alltraps>

00101e4a <vector62>:
.globl vector62
vector62:
  pushl $0
  101e4a:	6a 00                	push   $0x0
  pushl $62
  101e4c:	6a 3e                	push   $0x3e
  jmp __alltraps
  101e4e:	e9 49 08 00 00       	jmp    10269c <__alltraps>

00101e53 <vector63>:
.globl vector63
vector63:
  pushl $0
  101e53:	6a 00                	push   $0x0
  pushl $63
  101e55:	6a 3f                	push   $0x3f
  jmp __alltraps
  101e57:	e9 40 08 00 00       	jmp    10269c <__alltraps>

00101e5c <vector64>:
.globl vector64
vector64:
  pushl $0
  101e5c:	6a 00                	push   $0x0
  pushl $64
  101e5e:	6a 40                	push   $0x40
  jmp __alltraps
  101e60:	e9 37 08 00 00       	jmp    10269c <__alltraps>

00101e65 <vector65>:
.globl vector65
vector65:
  pushl $0
  101e65:	6a 00                	push   $0x0
  pushl $65
  101e67:	6a 41                	push   $0x41
  jmp __alltraps
  101e69:	e9 2e 08 00 00       	jmp    10269c <__alltraps>

00101e6e <vector66>:
.globl vector66
vector66:
  pushl $0
  101e6e:	6a 00                	push   $0x0
  pushl $66
  101e70:	6a 42                	push   $0x42
  jmp __alltraps
  101e72:	e9 25 08 00 00       	jmp    10269c <__alltraps>

00101e77 <vector67>:
.globl vector67
vector67:
  pushl $0
  101e77:	6a 00                	push   $0x0
  pushl $67
  101e79:	6a 43                	push   $0x43
  jmp __alltraps
  101e7b:	e9 1c 08 00 00       	jmp    10269c <__alltraps>

00101e80 <vector68>:
.globl vector68
vector68:
  pushl $0
  101e80:	6a 00                	push   $0x0
  pushl $68
  101e82:	6a 44                	push   $0x44
  jmp __alltraps
  101e84:	e9 13 08 00 00       	jmp    10269c <__alltraps>

00101e89 <vector69>:
.globl vector69
vector69:
  pushl $0
  101e89:	6a 00                	push   $0x0
  pushl $69
  101e8b:	6a 45                	push   $0x45
  jmp __alltraps
  101e8d:	e9 0a 08 00 00       	jmp    10269c <__alltraps>

00101e92 <vector70>:
.globl vector70
vector70:
  pushl $0
  101e92:	6a 00                	push   $0x0
  pushl $70
  101e94:	6a 46                	push   $0x46
  jmp __alltraps
  101e96:	e9 01 08 00 00       	jmp    10269c <__alltraps>

00101e9b <vector71>:
.globl vector71
vector71:
  pushl $0
  101e9b:	6a 00                	push   $0x0
  pushl $71
  101e9d:	6a 47                	push   $0x47
  jmp __alltraps
  101e9f:	e9 f8 07 00 00       	jmp    10269c <__alltraps>

00101ea4 <vector72>:
.globl vector72
vector72:
  pushl $0
  101ea4:	6a 00                	push   $0x0
  pushl $72
  101ea6:	6a 48                	push   $0x48
  jmp __alltraps
  101ea8:	e9 ef 07 00 00       	jmp    10269c <__alltraps>

00101ead <vector73>:
.globl vector73
vector73:
  pushl $0
  101ead:	6a 00                	push   $0x0
  pushl $73
  101eaf:	6a 49                	push   $0x49
  jmp __alltraps
  101eb1:	e9 e6 07 00 00       	jmp    10269c <__alltraps>

00101eb6 <vector74>:
.globl vector74
vector74:
  pushl $0
  101eb6:	6a 00                	push   $0x0
  pushl $74
  101eb8:	6a 4a                	push   $0x4a
  jmp __alltraps
  101eba:	e9 dd 07 00 00       	jmp    10269c <__alltraps>

00101ebf <vector75>:
.globl vector75
vector75:
  pushl $0
  101ebf:	6a 00                	push   $0x0
  pushl $75
  101ec1:	6a 4b                	push   $0x4b
  jmp __alltraps
  101ec3:	e9 d4 07 00 00       	jmp    10269c <__alltraps>

00101ec8 <vector76>:
.globl vector76
vector76:
  pushl $0
  101ec8:	6a 00                	push   $0x0
  pushl $76
  101eca:	6a 4c                	push   $0x4c
  jmp __alltraps
  101ecc:	e9 cb 07 00 00       	jmp    10269c <__alltraps>

00101ed1 <vector77>:
.globl vector77
vector77:
  pushl $0
  101ed1:	6a 00                	push   $0x0
  pushl $77
  101ed3:	6a 4d                	push   $0x4d
  jmp __alltraps
  101ed5:	e9 c2 07 00 00       	jmp    10269c <__alltraps>

00101eda <vector78>:
.globl vector78
vector78:
  pushl $0
  101eda:	6a 00                	push   $0x0
  pushl $78
  101edc:	6a 4e                	push   $0x4e
  jmp __alltraps
  101ede:	e9 b9 07 00 00       	jmp    10269c <__alltraps>

00101ee3 <vector79>:
.globl vector79
vector79:
  pushl $0
  101ee3:	6a 00                	push   $0x0
  pushl $79
  101ee5:	6a 4f                	push   $0x4f
  jmp __alltraps
  101ee7:	e9 b0 07 00 00       	jmp    10269c <__alltraps>

00101eec <vector80>:
.globl vector80
vector80:
  pushl $0
  101eec:	6a 00                	push   $0x0
  pushl $80
  101eee:	6a 50                	push   $0x50
  jmp __alltraps
  101ef0:	e9 a7 07 00 00       	jmp    10269c <__alltraps>

00101ef5 <vector81>:
.globl vector81
vector81:
  pushl $0
  101ef5:	6a 00                	push   $0x0
  pushl $81
  101ef7:	6a 51                	push   $0x51
  jmp __alltraps
  101ef9:	e9 9e 07 00 00       	jmp    10269c <__alltraps>

00101efe <vector82>:
.globl vector82
vector82:
  pushl $0
  101efe:	6a 00                	push   $0x0
  pushl $82
  101f00:	6a 52                	push   $0x52
  jmp __alltraps
  101f02:	e9 95 07 00 00       	jmp    10269c <__alltraps>

00101f07 <vector83>:
.globl vector83
vector83:
  pushl $0
  101f07:	6a 00                	push   $0x0
  pushl $83
  101f09:	6a 53                	push   $0x53
  jmp __alltraps
  101f0b:	e9 8c 07 00 00       	jmp    10269c <__alltraps>

00101f10 <vector84>:
.globl vector84
vector84:
  pushl $0
  101f10:	6a 00                	push   $0x0
  pushl $84
  101f12:	6a 54                	push   $0x54
  jmp __alltraps
  101f14:	e9 83 07 00 00       	jmp    10269c <__alltraps>

00101f19 <vector85>:
.globl vector85
vector85:
  pushl $0
  101f19:	6a 00                	push   $0x0
  pushl $85
  101f1b:	6a 55                	push   $0x55
  jmp __alltraps
  101f1d:	e9 7a 07 00 00       	jmp    10269c <__alltraps>

00101f22 <vector86>:
.globl vector86
vector86:
  pushl $0
  101f22:	6a 00                	push   $0x0
  pushl $86
  101f24:	6a 56                	push   $0x56
  jmp __alltraps
  101f26:	e9 71 07 00 00       	jmp    10269c <__alltraps>

00101f2b <vector87>:
.globl vector87
vector87:
  pushl $0
  101f2b:	6a 00                	push   $0x0
  pushl $87
  101f2d:	6a 57                	push   $0x57
  jmp __alltraps
  101f2f:	e9 68 07 00 00       	jmp    10269c <__alltraps>

00101f34 <vector88>:
.globl vector88
vector88:
  pushl $0
  101f34:	6a 00                	push   $0x0
  pushl $88
  101f36:	6a 58                	push   $0x58
  jmp __alltraps
  101f38:	e9 5f 07 00 00       	jmp    10269c <__alltraps>

00101f3d <vector89>:
.globl vector89
vector89:
  pushl $0
  101f3d:	6a 00                	push   $0x0
  pushl $89
  101f3f:	6a 59                	push   $0x59
  jmp __alltraps
  101f41:	e9 56 07 00 00       	jmp    10269c <__alltraps>

00101f46 <vector90>:
.globl vector90
vector90:
  pushl $0
  101f46:	6a 00                	push   $0x0
  pushl $90
  101f48:	6a 5a                	push   $0x5a
  jmp __alltraps
  101f4a:	e9 4d 07 00 00       	jmp    10269c <__alltraps>

00101f4f <vector91>:
.globl vector91
vector91:
  pushl $0
  101f4f:	6a 00                	push   $0x0
  pushl $91
  101f51:	6a 5b                	push   $0x5b
  jmp __alltraps
  101f53:	e9 44 07 00 00       	jmp    10269c <__alltraps>

00101f58 <vector92>:
.globl vector92
vector92:
  pushl $0
  101f58:	6a 00                	push   $0x0
  pushl $92
  101f5a:	6a 5c                	push   $0x5c
  jmp __alltraps
  101f5c:	e9 3b 07 00 00       	jmp    10269c <__alltraps>

00101f61 <vector93>:
.globl vector93
vector93:
  pushl $0
  101f61:	6a 00                	push   $0x0
  pushl $93
  101f63:	6a 5d                	push   $0x5d
  jmp __alltraps
  101f65:	e9 32 07 00 00       	jmp    10269c <__alltraps>

00101f6a <vector94>:
.globl vector94
vector94:
  pushl $0
  101f6a:	6a 00                	push   $0x0
  pushl $94
  101f6c:	6a 5e                	push   $0x5e
  jmp __alltraps
  101f6e:	e9 29 07 00 00       	jmp    10269c <__alltraps>

00101f73 <vector95>:
.globl vector95
vector95:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $95
  101f75:	6a 5f                	push   $0x5f
  jmp __alltraps
  101f77:	e9 20 07 00 00       	jmp    10269c <__alltraps>

00101f7c <vector96>:
.globl vector96
vector96:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $96
  101f7e:	6a 60                	push   $0x60
  jmp __alltraps
  101f80:	e9 17 07 00 00       	jmp    10269c <__alltraps>

00101f85 <vector97>:
.globl vector97
vector97:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $97
  101f87:	6a 61                	push   $0x61
  jmp __alltraps
  101f89:	e9 0e 07 00 00       	jmp    10269c <__alltraps>

00101f8e <vector98>:
.globl vector98
vector98:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $98
  101f90:	6a 62                	push   $0x62
  jmp __alltraps
  101f92:	e9 05 07 00 00       	jmp    10269c <__alltraps>

00101f97 <vector99>:
.globl vector99
vector99:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $99
  101f99:	6a 63                	push   $0x63
  jmp __alltraps
  101f9b:	e9 fc 06 00 00       	jmp    10269c <__alltraps>

00101fa0 <vector100>:
.globl vector100
vector100:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $100
  101fa2:	6a 64                	push   $0x64
  jmp __alltraps
  101fa4:	e9 f3 06 00 00       	jmp    10269c <__alltraps>

00101fa9 <vector101>:
.globl vector101
vector101:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $101
  101fab:	6a 65                	push   $0x65
  jmp __alltraps
  101fad:	e9 ea 06 00 00       	jmp    10269c <__alltraps>

00101fb2 <vector102>:
.globl vector102
vector102:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $102
  101fb4:	6a 66                	push   $0x66
  jmp __alltraps
  101fb6:	e9 e1 06 00 00       	jmp    10269c <__alltraps>

00101fbb <vector103>:
.globl vector103
vector103:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $103
  101fbd:	6a 67                	push   $0x67
  jmp __alltraps
  101fbf:	e9 d8 06 00 00       	jmp    10269c <__alltraps>

00101fc4 <vector104>:
.globl vector104
vector104:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $104
  101fc6:	6a 68                	push   $0x68
  jmp __alltraps
  101fc8:	e9 cf 06 00 00       	jmp    10269c <__alltraps>

00101fcd <vector105>:
.globl vector105
vector105:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $105
  101fcf:	6a 69                	push   $0x69
  jmp __alltraps
  101fd1:	e9 c6 06 00 00       	jmp    10269c <__alltraps>

00101fd6 <vector106>:
.globl vector106
vector106:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $106
  101fd8:	6a 6a                	push   $0x6a
  jmp __alltraps
  101fda:	e9 bd 06 00 00       	jmp    10269c <__alltraps>

00101fdf <vector107>:
.globl vector107
vector107:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $107
  101fe1:	6a 6b                	push   $0x6b
  jmp __alltraps
  101fe3:	e9 b4 06 00 00       	jmp    10269c <__alltraps>

00101fe8 <vector108>:
.globl vector108
vector108:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $108
  101fea:	6a 6c                	push   $0x6c
  jmp __alltraps
  101fec:	e9 ab 06 00 00       	jmp    10269c <__alltraps>

00101ff1 <vector109>:
.globl vector109
vector109:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $109
  101ff3:	6a 6d                	push   $0x6d
  jmp __alltraps
  101ff5:	e9 a2 06 00 00       	jmp    10269c <__alltraps>

00101ffa <vector110>:
.globl vector110
vector110:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $110
  101ffc:	6a 6e                	push   $0x6e
  jmp __alltraps
  101ffe:	e9 99 06 00 00       	jmp    10269c <__alltraps>

00102003 <vector111>:
.globl vector111
vector111:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $111
  102005:	6a 6f                	push   $0x6f
  jmp __alltraps
  102007:	e9 90 06 00 00       	jmp    10269c <__alltraps>

0010200c <vector112>:
.globl vector112
vector112:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $112
  10200e:	6a 70                	push   $0x70
  jmp __alltraps
  102010:	e9 87 06 00 00       	jmp    10269c <__alltraps>

00102015 <vector113>:
.globl vector113
vector113:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $113
  102017:	6a 71                	push   $0x71
  jmp __alltraps
  102019:	e9 7e 06 00 00       	jmp    10269c <__alltraps>

0010201e <vector114>:
.globl vector114
vector114:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $114
  102020:	6a 72                	push   $0x72
  jmp __alltraps
  102022:	e9 75 06 00 00       	jmp    10269c <__alltraps>

00102027 <vector115>:
.globl vector115
vector115:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $115
  102029:	6a 73                	push   $0x73
  jmp __alltraps
  10202b:	e9 6c 06 00 00       	jmp    10269c <__alltraps>

00102030 <vector116>:
.globl vector116
vector116:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $116
  102032:	6a 74                	push   $0x74
  jmp __alltraps
  102034:	e9 63 06 00 00       	jmp    10269c <__alltraps>

00102039 <vector117>:
.globl vector117
vector117:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $117
  10203b:	6a 75                	push   $0x75
  jmp __alltraps
  10203d:	e9 5a 06 00 00       	jmp    10269c <__alltraps>

00102042 <vector118>:
.globl vector118
vector118:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $118
  102044:	6a 76                	push   $0x76
  jmp __alltraps
  102046:	e9 51 06 00 00       	jmp    10269c <__alltraps>

0010204b <vector119>:
.globl vector119
vector119:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $119
  10204d:	6a 77                	push   $0x77
  jmp __alltraps
  10204f:	e9 48 06 00 00       	jmp    10269c <__alltraps>

00102054 <vector120>:
.globl vector120
vector120:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $120
  102056:	6a 78                	push   $0x78
  jmp __alltraps
  102058:	e9 3f 06 00 00       	jmp    10269c <__alltraps>

0010205d <vector121>:
.globl vector121
vector121:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $121
  10205f:	6a 79                	push   $0x79
  jmp __alltraps
  102061:	e9 36 06 00 00       	jmp    10269c <__alltraps>

00102066 <vector122>:
.globl vector122
vector122:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $122
  102068:	6a 7a                	push   $0x7a
  jmp __alltraps
  10206a:	e9 2d 06 00 00       	jmp    10269c <__alltraps>

0010206f <vector123>:
.globl vector123
vector123:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $123
  102071:	6a 7b                	push   $0x7b
  jmp __alltraps
  102073:	e9 24 06 00 00       	jmp    10269c <__alltraps>

00102078 <vector124>:
.globl vector124
vector124:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $124
  10207a:	6a 7c                	push   $0x7c
  jmp __alltraps
  10207c:	e9 1b 06 00 00       	jmp    10269c <__alltraps>

00102081 <vector125>:
.globl vector125
vector125:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $125
  102083:	6a 7d                	push   $0x7d
  jmp __alltraps
  102085:	e9 12 06 00 00       	jmp    10269c <__alltraps>

0010208a <vector126>:
.globl vector126
vector126:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $126
  10208c:	6a 7e                	push   $0x7e
  jmp __alltraps
  10208e:	e9 09 06 00 00       	jmp    10269c <__alltraps>

00102093 <vector127>:
.globl vector127
vector127:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $127
  102095:	6a 7f                	push   $0x7f
  jmp __alltraps
  102097:	e9 00 06 00 00       	jmp    10269c <__alltraps>

0010209c <vector128>:
.globl vector128
vector128:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $128
  10209e:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1020a3:	e9 f4 05 00 00       	jmp    10269c <__alltraps>

001020a8 <vector129>:
.globl vector129
vector129:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $129
  1020aa:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1020af:	e9 e8 05 00 00       	jmp    10269c <__alltraps>

001020b4 <vector130>:
.globl vector130
vector130:
  pushl $0
  1020b4:	6a 00                	push   $0x0
  pushl $130
  1020b6:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1020bb:	e9 dc 05 00 00       	jmp    10269c <__alltraps>

001020c0 <vector131>:
.globl vector131
vector131:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $131
  1020c2:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1020c7:	e9 d0 05 00 00       	jmp    10269c <__alltraps>

001020cc <vector132>:
.globl vector132
vector132:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $132
  1020ce:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1020d3:	e9 c4 05 00 00       	jmp    10269c <__alltraps>

001020d8 <vector133>:
.globl vector133
vector133:
  pushl $0
  1020d8:	6a 00                	push   $0x0
  pushl $133
  1020da:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1020df:	e9 b8 05 00 00       	jmp    10269c <__alltraps>

001020e4 <vector134>:
.globl vector134
vector134:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $134
  1020e6:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1020eb:	e9 ac 05 00 00       	jmp    10269c <__alltraps>

001020f0 <vector135>:
.globl vector135
vector135:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $135
  1020f2:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1020f7:	e9 a0 05 00 00       	jmp    10269c <__alltraps>

001020fc <vector136>:
.globl vector136
vector136:
  pushl $0
  1020fc:	6a 00                	push   $0x0
  pushl $136
  1020fe:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102103:	e9 94 05 00 00       	jmp    10269c <__alltraps>

00102108 <vector137>:
.globl vector137
vector137:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $137
  10210a:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10210f:	e9 88 05 00 00       	jmp    10269c <__alltraps>

00102114 <vector138>:
.globl vector138
vector138:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $138
  102116:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10211b:	e9 7c 05 00 00       	jmp    10269c <__alltraps>

00102120 <vector139>:
.globl vector139
vector139:
  pushl $0
  102120:	6a 00                	push   $0x0
  pushl $139
  102122:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102127:	e9 70 05 00 00       	jmp    10269c <__alltraps>

0010212c <vector140>:
.globl vector140
vector140:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $140
  10212e:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102133:	e9 64 05 00 00       	jmp    10269c <__alltraps>

00102138 <vector141>:
.globl vector141
vector141:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $141
  10213a:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10213f:	e9 58 05 00 00       	jmp    10269c <__alltraps>

00102144 <vector142>:
.globl vector142
vector142:
  pushl $0
  102144:	6a 00                	push   $0x0
  pushl $142
  102146:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10214b:	e9 4c 05 00 00       	jmp    10269c <__alltraps>

00102150 <vector143>:
.globl vector143
vector143:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $143
  102152:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102157:	e9 40 05 00 00       	jmp    10269c <__alltraps>

0010215c <vector144>:
.globl vector144
vector144:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $144
  10215e:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102163:	e9 34 05 00 00       	jmp    10269c <__alltraps>

00102168 <vector145>:
.globl vector145
vector145:
  pushl $0
  102168:	6a 00                	push   $0x0
  pushl $145
  10216a:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10216f:	e9 28 05 00 00       	jmp    10269c <__alltraps>

00102174 <vector146>:
.globl vector146
vector146:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $146
  102176:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10217b:	e9 1c 05 00 00       	jmp    10269c <__alltraps>

00102180 <vector147>:
.globl vector147
vector147:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $147
  102182:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102187:	e9 10 05 00 00       	jmp    10269c <__alltraps>

0010218c <vector148>:
.globl vector148
vector148:
  pushl $0
  10218c:	6a 00                	push   $0x0
  pushl $148
  10218e:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102193:	e9 04 05 00 00       	jmp    10269c <__alltraps>

00102198 <vector149>:
.globl vector149
vector149:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $149
  10219a:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10219f:	e9 f8 04 00 00       	jmp    10269c <__alltraps>

001021a4 <vector150>:
.globl vector150
vector150:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $150
  1021a6:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1021ab:	e9 ec 04 00 00       	jmp    10269c <__alltraps>

001021b0 <vector151>:
.globl vector151
vector151:
  pushl $0
  1021b0:	6a 00                	push   $0x0
  pushl $151
  1021b2:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1021b7:	e9 e0 04 00 00       	jmp    10269c <__alltraps>

001021bc <vector152>:
.globl vector152
vector152:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $152
  1021be:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1021c3:	e9 d4 04 00 00       	jmp    10269c <__alltraps>

001021c8 <vector153>:
.globl vector153
vector153:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $153
  1021ca:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1021cf:	e9 c8 04 00 00       	jmp    10269c <__alltraps>

001021d4 <vector154>:
.globl vector154
vector154:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $154
  1021d6:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1021db:	e9 bc 04 00 00       	jmp    10269c <__alltraps>

001021e0 <vector155>:
.globl vector155
vector155:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $155
  1021e2:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1021e7:	e9 b0 04 00 00       	jmp    10269c <__alltraps>

001021ec <vector156>:
.globl vector156
vector156:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $156
  1021ee:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1021f3:	e9 a4 04 00 00       	jmp    10269c <__alltraps>

001021f8 <vector157>:
.globl vector157
vector157:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $157
  1021fa:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1021ff:	e9 98 04 00 00       	jmp    10269c <__alltraps>

00102204 <vector158>:
.globl vector158
vector158:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $158
  102206:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10220b:	e9 8c 04 00 00       	jmp    10269c <__alltraps>

00102210 <vector159>:
.globl vector159
vector159:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $159
  102212:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102217:	e9 80 04 00 00       	jmp    10269c <__alltraps>

0010221c <vector160>:
.globl vector160
vector160:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $160
  10221e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102223:	e9 74 04 00 00       	jmp    10269c <__alltraps>

00102228 <vector161>:
.globl vector161
vector161:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $161
  10222a:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10222f:	e9 68 04 00 00       	jmp    10269c <__alltraps>

00102234 <vector162>:
.globl vector162
vector162:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $162
  102236:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10223b:	e9 5c 04 00 00       	jmp    10269c <__alltraps>

00102240 <vector163>:
.globl vector163
vector163:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $163
  102242:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102247:	e9 50 04 00 00       	jmp    10269c <__alltraps>

0010224c <vector164>:
.globl vector164
vector164:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $164
  10224e:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102253:	e9 44 04 00 00       	jmp    10269c <__alltraps>

00102258 <vector165>:
.globl vector165
vector165:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $165
  10225a:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10225f:	e9 38 04 00 00       	jmp    10269c <__alltraps>

00102264 <vector166>:
.globl vector166
vector166:
  pushl $0
  102264:	6a 00                	push   $0x0
  pushl $166
  102266:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10226b:	e9 2c 04 00 00       	jmp    10269c <__alltraps>

00102270 <vector167>:
.globl vector167
vector167:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $167
  102272:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102277:	e9 20 04 00 00       	jmp    10269c <__alltraps>

0010227c <vector168>:
.globl vector168
vector168:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $168
  10227e:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102283:	e9 14 04 00 00       	jmp    10269c <__alltraps>

00102288 <vector169>:
.globl vector169
vector169:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $169
  10228a:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10228f:	e9 08 04 00 00       	jmp    10269c <__alltraps>

00102294 <vector170>:
.globl vector170
vector170:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $170
  102296:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10229b:	e9 fc 03 00 00       	jmp    10269c <__alltraps>

001022a0 <vector171>:
.globl vector171
vector171:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $171
  1022a2:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1022a7:	e9 f0 03 00 00       	jmp    10269c <__alltraps>

001022ac <vector172>:
.globl vector172
vector172:
  pushl $0
  1022ac:	6a 00                	push   $0x0
  pushl $172
  1022ae:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1022b3:	e9 e4 03 00 00       	jmp    10269c <__alltraps>

001022b8 <vector173>:
.globl vector173
vector173:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $173
  1022ba:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1022bf:	e9 d8 03 00 00       	jmp    10269c <__alltraps>

001022c4 <vector174>:
.globl vector174
vector174:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $174
  1022c6:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1022cb:	e9 cc 03 00 00       	jmp    10269c <__alltraps>

001022d0 <vector175>:
.globl vector175
vector175:
  pushl $0
  1022d0:	6a 00                	push   $0x0
  pushl $175
  1022d2:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1022d7:	e9 c0 03 00 00       	jmp    10269c <__alltraps>

001022dc <vector176>:
.globl vector176
vector176:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $176
  1022de:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1022e3:	e9 b4 03 00 00       	jmp    10269c <__alltraps>

001022e8 <vector177>:
.globl vector177
vector177:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $177
  1022ea:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1022ef:	e9 a8 03 00 00       	jmp    10269c <__alltraps>

001022f4 <vector178>:
.globl vector178
vector178:
  pushl $0
  1022f4:	6a 00                	push   $0x0
  pushl $178
  1022f6:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1022fb:	e9 9c 03 00 00       	jmp    10269c <__alltraps>

00102300 <vector179>:
.globl vector179
vector179:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $179
  102302:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102307:	e9 90 03 00 00       	jmp    10269c <__alltraps>

0010230c <vector180>:
.globl vector180
vector180:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $180
  10230e:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102313:	e9 84 03 00 00       	jmp    10269c <__alltraps>

00102318 <vector181>:
.globl vector181
vector181:
  pushl $0
  102318:	6a 00                	push   $0x0
  pushl $181
  10231a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10231f:	e9 78 03 00 00       	jmp    10269c <__alltraps>

00102324 <vector182>:
.globl vector182
vector182:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $182
  102326:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10232b:	e9 6c 03 00 00       	jmp    10269c <__alltraps>

00102330 <vector183>:
.globl vector183
vector183:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $183
  102332:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102337:	e9 60 03 00 00       	jmp    10269c <__alltraps>

0010233c <vector184>:
.globl vector184
vector184:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $184
  10233e:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102343:	e9 54 03 00 00       	jmp    10269c <__alltraps>

00102348 <vector185>:
.globl vector185
vector185:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $185
  10234a:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10234f:	e9 48 03 00 00       	jmp    10269c <__alltraps>

00102354 <vector186>:
.globl vector186
vector186:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $186
  102356:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10235b:	e9 3c 03 00 00       	jmp    10269c <__alltraps>

00102360 <vector187>:
.globl vector187
vector187:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $187
  102362:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102367:	e9 30 03 00 00       	jmp    10269c <__alltraps>

0010236c <vector188>:
.globl vector188
vector188:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $188
  10236e:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102373:	e9 24 03 00 00       	jmp    10269c <__alltraps>

00102378 <vector189>:
.globl vector189
vector189:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $189
  10237a:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10237f:	e9 18 03 00 00       	jmp    10269c <__alltraps>

00102384 <vector190>:
.globl vector190
vector190:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $190
  102386:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10238b:	e9 0c 03 00 00       	jmp    10269c <__alltraps>

00102390 <vector191>:
.globl vector191
vector191:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $191
  102392:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102397:	e9 00 03 00 00       	jmp    10269c <__alltraps>

0010239c <vector192>:
.globl vector192
vector192:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $192
  10239e:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1023a3:	e9 f4 02 00 00       	jmp    10269c <__alltraps>

001023a8 <vector193>:
.globl vector193
vector193:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $193
  1023aa:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1023af:	e9 e8 02 00 00       	jmp    10269c <__alltraps>

001023b4 <vector194>:
.globl vector194
vector194:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $194
  1023b6:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1023bb:	e9 dc 02 00 00       	jmp    10269c <__alltraps>

001023c0 <vector195>:
.globl vector195
vector195:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $195
  1023c2:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1023c7:	e9 d0 02 00 00       	jmp    10269c <__alltraps>

001023cc <vector196>:
.globl vector196
vector196:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $196
  1023ce:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1023d3:	e9 c4 02 00 00       	jmp    10269c <__alltraps>

001023d8 <vector197>:
.globl vector197
vector197:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $197
  1023da:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1023df:	e9 b8 02 00 00       	jmp    10269c <__alltraps>

001023e4 <vector198>:
.globl vector198
vector198:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $198
  1023e6:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1023eb:	e9 ac 02 00 00       	jmp    10269c <__alltraps>

001023f0 <vector199>:
.globl vector199
vector199:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $199
  1023f2:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1023f7:	e9 a0 02 00 00       	jmp    10269c <__alltraps>

001023fc <vector200>:
.globl vector200
vector200:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $200
  1023fe:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102403:	e9 94 02 00 00       	jmp    10269c <__alltraps>

00102408 <vector201>:
.globl vector201
vector201:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $201
  10240a:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10240f:	e9 88 02 00 00       	jmp    10269c <__alltraps>

00102414 <vector202>:
.globl vector202
vector202:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $202
  102416:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10241b:	e9 7c 02 00 00       	jmp    10269c <__alltraps>

00102420 <vector203>:
.globl vector203
vector203:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $203
  102422:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102427:	e9 70 02 00 00       	jmp    10269c <__alltraps>

0010242c <vector204>:
.globl vector204
vector204:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $204
  10242e:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102433:	e9 64 02 00 00       	jmp    10269c <__alltraps>

00102438 <vector205>:
.globl vector205
vector205:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $205
  10243a:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10243f:	e9 58 02 00 00       	jmp    10269c <__alltraps>

00102444 <vector206>:
.globl vector206
vector206:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $206
  102446:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10244b:	e9 4c 02 00 00       	jmp    10269c <__alltraps>

00102450 <vector207>:
.globl vector207
vector207:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $207
  102452:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102457:	e9 40 02 00 00       	jmp    10269c <__alltraps>

0010245c <vector208>:
.globl vector208
vector208:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $208
  10245e:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102463:	e9 34 02 00 00       	jmp    10269c <__alltraps>

00102468 <vector209>:
.globl vector209
vector209:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $209
  10246a:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10246f:	e9 28 02 00 00       	jmp    10269c <__alltraps>

00102474 <vector210>:
.globl vector210
vector210:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $210
  102476:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10247b:	e9 1c 02 00 00       	jmp    10269c <__alltraps>

00102480 <vector211>:
.globl vector211
vector211:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $211
  102482:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102487:	e9 10 02 00 00       	jmp    10269c <__alltraps>

0010248c <vector212>:
.globl vector212
vector212:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $212
  10248e:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102493:	e9 04 02 00 00       	jmp    10269c <__alltraps>

00102498 <vector213>:
.globl vector213
vector213:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $213
  10249a:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10249f:	e9 f8 01 00 00       	jmp    10269c <__alltraps>

001024a4 <vector214>:
.globl vector214
vector214:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $214
  1024a6:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1024ab:	e9 ec 01 00 00       	jmp    10269c <__alltraps>

001024b0 <vector215>:
.globl vector215
vector215:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $215
  1024b2:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1024b7:	e9 e0 01 00 00       	jmp    10269c <__alltraps>

001024bc <vector216>:
.globl vector216
vector216:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $216
  1024be:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1024c3:	e9 d4 01 00 00       	jmp    10269c <__alltraps>

001024c8 <vector217>:
.globl vector217
vector217:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $217
  1024ca:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1024cf:	e9 c8 01 00 00       	jmp    10269c <__alltraps>

001024d4 <vector218>:
.globl vector218
vector218:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $218
  1024d6:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1024db:	e9 bc 01 00 00       	jmp    10269c <__alltraps>

001024e0 <vector219>:
.globl vector219
vector219:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $219
  1024e2:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1024e7:	e9 b0 01 00 00       	jmp    10269c <__alltraps>

001024ec <vector220>:
.globl vector220
vector220:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $220
  1024ee:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1024f3:	e9 a4 01 00 00       	jmp    10269c <__alltraps>

001024f8 <vector221>:
.globl vector221
vector221:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $221
  1024fa:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1024ff:	e9 98 01 00 00       	jmp    10269c <__alltraps>

00102504 <vector222>:
.globl vector222
vector222:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $222
  102506:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10250b:	e9 8c 01 00 00       	jmp    10269c <__alltraps>

00102510 <vector223>:
.globl vector223
vector223:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $223
  102512:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102517:	e9 80 01 00 00       	jmp    10269c <__alltraps>

0010251c <vector224>:
.globl vector224
vector224:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $224
  10251e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102523:	e9 74 01 00 00       	jmp    10269c <__alltraps>

00102528 <vector225>:
.globl vector225
vector225:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $225
  10252a:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10252f:	e9 68 01 00 00       	jmp    10269c <__alltraps>

00102534 <vector226>:
.globl vector226
vector226:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $226
  102536:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10253b:	e9 5c 01 00 00       	jmp    10269c <__alltraps>

00102540 <vector227>:
.globl vector227
vector227:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $227
  102542:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102547:	e9 50 01 00 00       	jmp    10269c <__alltraps>

0010254c <vector228>:
.globl vector228
vector228:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $228
  10254e:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102553:	e9 44 01 00 00       	jmp    10269c <__alltraps>

00102558 <vector229>:
.globl vector229
vector229:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $229
  10255a:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10255f:	e9 38 01 00 00       	jmp    10269c <__alltraps>

00102564 <vector230>:
.globl vector230
vector230:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $230
  102566:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10256b:	e9 2c 01 00 00       	jmp    10269c <__alltraps>

00102570 <vector231>:
.globl vector231
vector231:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $231
  102572:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102577:	e9 20 01 00 00       	jmp    10269c <__alltraps>

0010257c <vector232>:
.globl vector232
vector232:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $232
  10257e:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102583:	e9 14 01 00 00       	jmp    10269c <__alltraps>

00102588 <vector233>:
.globl vector233
vector233:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $233
  10258a:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10258f:	e9 08 01 00 00       	jmp    10269c <__alltraps>

00102594 <vector234>:
.globl vector234
vector234:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $234
  102596:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10259b:	e9 fc 00 00 00       	jmp    10269c <__alltraps>

001025a0 <vector235>:
.globl vector235
vector235:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $235
  1025a2:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1025a7:	e9 f0 00 00 00       	jmp    10269c <__alltraps>

001025ac <vector236>:
.globl vector236
vector236:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $236
  1025ae:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1025b3:	e9 e4 00 00 00       	jmp    10269c <__alltraps>

001025b8 <vector237>:
.globl vector237
vector237:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $237
  1025ba:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1025bf:	e9 d8 00 00 00       	jmp    10269c <__alltraps>

001025c4 <vector238>:
.globl vector238
vector238:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $238
  1025c6:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1025cb:	e9 cc 00 00 00       	jmp    10269c <__alltraps>

001025d0 <vector239>:
.globl vector239
vector239:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $239
  1025d2:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1025d7:	e9 c0 00 00 00       	jmp    10269c <__alltraps>

001025dc <vector240>:
.globl vector240
vector240:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $240
  1025de:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1025e3:	e9 b4 00 00 00       	jmp    10269c <__alltraps>

001025e8 <vector241>:
.globl vector241
vector241:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $241
  1025ea:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1025ef:	e9 a8 00 00 00       	jmp    10269c <__alltraps>

001025f4 <vector242>:
.globl vector242
vector242:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $242
  1025f6:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1025fb:	e9 9c 00 00 00       	jmp    10269c <__alltraps>

00102600 <vector243>:
.globl vector243
vector243:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $243
  102602:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102607:	e9 90 00 00 00       	jmp    10269c <__alltraps>

0010260c <vector244>:
.globl vector244
vector244:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $244
  10260e:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102613:	e9 84 00 00 00       	jmp    10269c <__alltraps>

00102618 <vector245>:
.globl vector245
vector245:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $245
  10261a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10261f:	e9 78 00 00 00       	jmp    10269c <__alltraps>

00102624 <vector246>:
.globl vector246
vector246:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $246
  102626:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10262b:	e9 6c 00 00 00       	jmp    10269c <__alltraps>

00102630 <vector247>:
.globl vector247
vector247:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $247
  102632:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102637:	e9 60 00 00 00       	jmp    10269c <__alltraps>

0010263c <vector248>:
.globl vector248
vector248:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $248
  10263e:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102643:	e9 54 00 00 00       	jmp    10269c <__alltraps>

00102648 <vector249>:
.globl vector249
vector249:
  pushl $0
  102648:	6a 00                	push   $0x0
  pushl $249
  10264a:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10264f:	e9 48 00 00 00       	jmp    10269c <__alltraps>

00102654 <vector250>:
.globl vector250
vector250:
  pushl $0
  102654:	6a 00                	push   $0x0
  pushl $250
  102656:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10265b:	e9 3c 00 00 00       	jmp    10269c <__alltraps>

00102660 <vector251>:
.globl vector251
vector251:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $251
  102662:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102667:	e9 30 00 00 00       	jmp    10269c <__alltraps>

0010266c <vector252>:
.globl vector252
vector252:
  pushl $0
  10266c:	6a 00                	push   $0x0
  pushl $252
  10266e:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102673:	e9 24 00 00 00       	jmp    10269c <__alltraps>

00102678 <vector253>:
.globl vector253
vector253:
  pushl $0
  102678:	6a 00                	push   $0x0
  pushl $253
  10267a:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10267f:	e9 18 00 00 00       	jmp    10269c <__alltraps>

00102684 <vector254>:
.globl vector254
vector254:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $254
  102686:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10268b:	e9 0c 00 00 00       	jmp    10269c <__alltraps>

00102690 <vector255>:
.globl vector255
vector255:
  pushl $0
  102690:	6a 00                	push   $0x0
  pushl $255
  102692:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102697:	e9 00 00 00 00       	jmp    10269c <__alltraps>

0010269c <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10269c:	1e                   	push   %ds
    pushl %es
  10269d:	06                   	push   %es
    pushl %fs
  10269e:	0f a0                	push   %fs
    pushl %gs
  1026a0:	0f a8                	push   %gs
    pushal
  1026a2:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1026a3:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1026a8:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1026aa:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1026ac:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1026ad:	e8 60 f5 ff ff       	call   101c12 <trap>

    # pop the pushed stack pointer
    popl %esp
  1026b2:	5c                   	pop    %esp

001026b3 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1026b3:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  1026b4:	0f a9                	pop    %gs
    popl %fs
  1026b6:	0f a1                	pop    %fs
    popl %es
  1026b8:	07                   	pop    %es
    popl %ds
  1026b9:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1026ba:	83 c4 08             	add    $0x8,%esp
    iret
  1026bd:	cf                   	iret   

001026be <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1026be:	55                   	push   %ebp
  1026bf:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1026c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1026c4:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1026c7:	b8 23 00 00 00       	mov    $0x23,%eax
  1026cc:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1026ce:	b8 23 00 00 00       	mov    $0x23,%eax
  1026d3:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1026d5:	b8 10 00 00 00       	mov    $0x10,%eax
  1026da:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1026dc:	b8 10 00 00 00       	mov    $0x10,%eax
  1026e1:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1026e3:	b8 10 00 00 00       	mov    $0x10,%eax
  1026e8:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1026ea:	ea f1 26 10 00 08 00 	ljmp   $0x8,$0x1026f1
}
  1026f1:	90                   	nop
  1026f2:	5d                   	pop    %ebp
  1026f3:	c3                   	ret    

001026f4 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1026f4:	f3 0f 1e fb          	endbr32 
  1026f8:	55                   	push   %ebp
  1026f9:	89 e5                	mov    %esp,%ebp
  1026fb:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1026fe:	b8 20 09 11 00       	mov    $0x110920,%eax
  102703:	05 00 04 00 00       	add    $0x400,%eax
  102708:	a3 a4 08 11 00       	mov    %eax,0x1108a4
    ts.ts_ss0 = KERNEL_DS;
  10270d:	66 c7 05 a8 08 11 00 	movw   $0x10,0x1108a8
  102714:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102716:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  10271d:	68 00 
  10271f:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102724:	0f b7 c0             	movzwl %ax,%eax
  102727:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  10272d:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102732:	c1 e8 10             	shr    $0x10,%eax
  102735:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  10273a:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102741:	24 f0                	and    $0xf0,%al
  102743:	0c 09                	or     $0x9,%al
  102745:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  10274a:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102751:	0c 10                	or     $0x10,%al
  102753:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102758:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  10275f:	24 9f                	and    $0x9f,%al
  102761:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102766:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  10276d:	0c 80                	or     $0x80,%al
  10276f:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102774:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  10277b:	24 f0                	and    $0xf0,%al
  10277d:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102782:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102789:	24 ef                	and    $0xef,%al
  10278b:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102790:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102797:	24 df                	and    $0xdf,%al
  102799:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  10279e:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  1027a5:	0c 40                	or     $0x40,%al
  1027a7:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  1027ac:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  1027b3:	24 7f                	and    $0x7f,%al
  1027b5:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  1027ba:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  1027bf:	c1 e8 18             	shr    $0x18,%eax
  1027c2:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  1027c7:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  1027ce:	24 ef                	and    $0xef,%al
  1027d0:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  1027d5:	c7 04 24 10 fa 10 00 	movl   $0x10fa10,(%esp)
  1027dc:	e8 dd fe ff ff       	call   1026be <lgdt>
  1027e1:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  1027e7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1027eb:	0f 00 d8             	ltr    %ax
}
  1027ee:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  1027ef:	90                   	nop
  1027f0:	c9                   	leave  
  1027f1:	c3                   	ret    

001027f2 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  1027f2:	f3 0f 1e fb          	endbr32 
  1027f6:	55                   	push   %ebp
  1027f7:	89 e5                	mov    %esp,%ebp
    gdt_init();
  1027f9:	e8 f6 fe ff ff       	call   1026f4 <gdt_init>
}
  1027fe:	90                   	nop
  1027ff:	5d                   	pop    %ebp
  102800:	c3                   	ret    

00102801 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102801:	f3 0f 1e fb          	endbr32 
  102805:	55                   	push   %ebp
  102806:	89 e5                	mov    %esp,%ebp
  102808:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10280b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102812:	eb 03                	jmp    102817 <strlen+0x16>
        cnt ++;
  102814:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102817:	8b 45 08             	mov    0x8(%ebp),%eax
  10281a:	8d 50 01             	lea    0x1(%eax),%edx
  10281d:	89 55 08             	mov    %edx,0x8(%ebp)
  102820:	0f b6 00             	movzbl (%eax),%eax
  102823:	84 c0                	test   %al,%al
  102825:	75 ed                	jne    102814 <strlen+0x13>
    }
    return cnt;
  102827:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10282a:	c9                   	leave  
  10282b:	c3                   	ret    

0010282c <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10282c:	f3 0f 1e fb          	endbr32 
  102830:	55                   	push   %ebp
  102831:	89 e5                	mov    %esp,%ebp
  102833:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102836:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10283d:	eb 03                	jmp    102842 <strnlen+0x16>
        cnt ++;
  10283f:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102842:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102845:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102848:	73 10                	jae    10285a <strnlen+0x2e>
  10284a:	8b 45 08             	mov    0x8(%ebp),%eax
  10284d:	8d 50 01             	lea    0x1(%eax),%edx
  102850:	89 55 08             	mov    %edx,0x8(%ebp)
  102853:	0f b6 00             	movzbl (%eax),%eax
  102856:	84 c0                	test   %al,%al
  102858:	75 e5                	jne    10283f <strnlen+0x13>
    }
    return cnt;
  10285a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10285d:	c9                   	leave  
  10285e:	c3                   	ret    

0010285f <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10285f:	f3 0f 1e fb          	endbr32 
  102863:	55                   	push   %ebp
  102864:	89 e5                	mov    %esp,%ebp
  102866:	57                   	push   %edi
  102867:	56                   	push   %esi
  102868:	83 ec 20             	sub    $0x20,%esp
  10286b:	8b 45 08             	mov    0x8(%ebp),%eax
  10286e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102871:	8b 45 0c             	mov    0xc(%ebp),%eax
  102874:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102877:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10287d:	89 d1                	mov    %edx,%ecx
  10287f:	89 c2                	mov    %eax,%edx
  102881:	89 ce                	mov    %ecx,%esi
  102883:	89 d7                	mov    %edx,%edi
  102885:	ac                   	lods   %ds:(%esi),%al
  102886:	aa                   	stos   %al,%es:(%edi)
  102887:	84 c0                	test   %al,%al
  102889:	75 fa                	jne    102885 <strcpy+0x26>
  10288b:	89 fa                	mov    %edi,%edx
  10288d:	89 f1                	mov    %esi,%ecx
  10288f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102892:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102895:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102898:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10289b:	83 c4 20             	add    $0x20,%esp
  10289e:	5e                   	pop    %esi
  10289f:	5f                   	pop    %edi
  1028a0:	5d                   	pop    %ebp
  1028a1:	c3                   	ret    

001028a2 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1028a2:	f3 0f 1e fb          	endbr32 
  1028a6:	55                   	push   %ebp
  1028a7:	89 e5                	mov    %esp,%ebp
  1028a9:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1028af:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1028b2:	eb 1e                	jmp    1028d2 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  1028b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1028b7:	0f b6 10             	movzbl (%eax),%edx
  1028ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028bd:	88 10                	mov    %dl,(%eax)
  1028bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028c2:	0f b6 00             	movzbl (%eax),%eax
  1028c5:	84 c0                	test   %al,%al
  1028c7:	74 03                	je     1028cc <strncpy+0x2a>
            src ++;
  1028c9:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  1028cc:	ff 45 fc             	incl   -0x4(%ebp)
  1028cf:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  1028d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1028d6:	75 dc                	jne    1028b4 <strncpy+0x12>
    }
    return dst;
  1028d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1028db:	c9                   	leave  
  1028dc:	c3                   	ret    

001028dd <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1028dd:	f3 0f 1e fb          	endbr32 
  1028e1:	55                   	push   %ebp
  1028e2:	89 e5                	mov    %esp,%ebp
  1028e4:	57                   	push   %edi
  1028e5:	56                   	push   %esi
  1028e6:	83 ec 20             	sub    $0x20,%esp
  1028e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1028ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1028ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1028f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1028f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1028f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1028fb:	89 d1                	mov    %edx,%ecx
  1028fd:	89 c2                	mov    %eax,%edx
  1028ff:	89 ce                	mov    %ecx,%esi
  102901:	89 d7                	mov    %edx,%edi
  102903:	ac                   	lods   %ds:(%esi),%al
  102904:	ae                   	scas   %es:(%edi),%al
  102905:	75 08                	jne    10290f <strcmp+0x32>
  102907:	84 c0                	test   %al,%al
  102909:	75 f8                	jne    102903 <strcmp+0x26>
  10290b:	31 c0                	xor    %eax,%eax
  10290d:	eb 04                	jmp    102913 <strcmp+0x36>
  10290f:	19 c0                	sbb    %eax,%eax
  102911:	0c 01                	or     $0x1,%al
  102913:	89 fa                	mov    %edi,%edx
  102915:	89 f1                	mov    %esi,%ecx
  102917:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10291a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10291d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102920:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102923:	83 c4 20             	add    $0x20,%esp
  102926:	5e                   	pop    %esi
  102927:	5f                   	pop    %edi
  102928:	5d                   	pop    %ebp
  102929:	c3                   	ret    

0010292a <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10292a:	f3 0f 1e fb          	endbr32 
  10292e:	55                   	push   %ebp
  10292f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102931:	eb 09                	jmp    10293c <strncmp+0x12>
        n --, s1 ++, s2 ++;
  102933:	ff 4d 10             	decl   0x10(%ebp)
  102936:	ff 45 08             	incl   0x8(%ebp)
  102939:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10293c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102940:	74 1a                	je     10295c <strncmp+0x32>
  102942:	8b 45 08             	mov    0x8(%ebp),%eax
  102945:	0f b6 00             	movzbl (%eax),%eax
  102948:	84 c0                	test   %al,%al
  10294a:	74 10                	je     10295c <strncmp+0x32>
  10294c:	8b 45 08             	mov    0x8(%ebp),%eax
  10294f:	0f b6 10             	movzbl (%eax),%edx
  102952:	8b 45 0c             	mov    0xc(%ebp),%eax
  102955:	0f b6 00             	movzbl (%eax),%eax
  102958:	38 c2                	cmp    %al,%dl
  10295a:	74 d7                	je     102933 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10295c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102960:	74 18                	je     10297a <strncmp+0x50>
  102962:	8b 45 08             	mov    0x8(%ebp),%eax
  102965:	0f b6 00             	movzbl (%eax),%eax
  102968:	0f b6 d0             	movzbl %al,%edx
  10296b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10296e:	0f b6 00             	movzbl (%eax),%eax
  102971:	0f b6 c0             	movzbl %al,%eax
  102974:	29 c2                	sub    %eax,%edx
  102976:	89 d0                	mov    %edx,%eax
  102978:	eb 05                	jmp    10297f <strncmp+0x55>
  10297a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10297f:	5d                   	pop    %ebp
  102980:	c3                   	ret    

00102981 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102981:	f3 0f 1e fb          	endbr32 
  102985:	55                   	push   %ebp
  102986:	89 e5                	mov    %esp,%ebp
  102988:	83 ec 04             	sub    $0x4,%esp
  10298b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10298e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102991:	eb 13                	jmp    1029a6 <strchr+0x25>
        if (*s == c) {
  102993:	8b 45 08             	mov    0x8(%ebp),%eax
  102996:	0f b6 00             	movzbl (%eax),%eax
  102999:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10299c:	75 05                	jne    1029a3 <strchr+0x22>
            return (char *)s;
  10299e:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a1:	eb 12                	jmp    1029b5 <strchr+0x34>
        }
        s ++;
  1029a3:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a9:	0f b6 00             	movzbl (%eax),%eax
  1029ac:	84 c0                	test   %al,%al
  1029ae:	75 e3                	jne    102993 <strchr+0x12>
    }
    return NULL;
  1029b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1029b5:	c9                   	leave  
  1029b6:	c3                   	ret    

001029b7 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1029b7:	f3 0f 1e fb          	endbr32 
  1029bb:	55                   	push   %ebp
  1029bc:	89 e5                	mov    %esp,%ebp
  1029be:	83 ec 04             	sub    $0x4,%esp
  1029c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029c4:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1029c7:	eb 0e                	jmp    1029d7 <strfind+0x20>
        if (*s == c) {
  1029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1029cc:	0f b6 00             	movzbl (%eax),%eax
  1029cf:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1029d2:	74 0f                	je     1029e3 <strfind+0x2c>
            break;
        }
        s ++;
  1029d4:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1029da:	0f b6 00             	movzbl (%eax),%eax
  1029dd:	84 c0                	test   %al,%al
  1029df:	75 e8                	jne    1029c9 <strfind+0x12>
  1029e1:	eb 01                	jmp    1029e4 <strfind+0x2d>
            break;
  1029e3:	90                   	nop
    }
    return (char *)s;
  1029e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1029e7:	c9                   	leave  
  1029e8:	c3                   	ret    

001029e9 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1029e9:	f3 0f 1e fb          	endbr32 
  1029ed:	55                   	push   %ebp
  1029ee:	89 e5                	mov    %esp,%ebp
  1029f0:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1029f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1029fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102a01:	eb 03                	jmp    102a06 <strtol+0x1d>
        s ++;
  102a03:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102a06:	8b 45 08             	mov    0x8(%ebp),%eax
  102a09:	0f b6 00             	movzbl (%eax),%eax
  102a0c:	3c 20                	cmp    $0x20,%al
  102a0e:	74 f3                	je     102a03 <strtol+0x1a>
  102a10:	8b 45 08             	mov    0x8(%ebp),%eax
  102a13:	0f b6 00             	movzbl (%eax),%eax
  102a16:	3c 09                	cmp    $0x9,%al
  102a18:	74 e9                	je     102a03 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  102a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a1d:	0f b6 00             	movzbl (%eax),%eax
  102a20:	3c 2b                	cmp    $0x2b,%al
  102a22:	75 05                	jne    102a29 <strtol+0x40>
        s ++;
  102a24:	ff 45 08             	incl   0x8(%ebp)
  102a27:	eb 14                	jmp    102a3d <strtol+0x54>
    }
    else if (*s == '-') {
  102a29:	8b 45 08             	mov    0x8(%ebp),%eax
  102a2c:	0f b6 00             	movzbl (%eax),%eax
  102a2f:	3c 2d                	cmp    $0x2d,%al
  102a31:	75 0a                	jne    102a3d <strtol+0x54>
        s ++, neg = 1;
  102a33:	ff 45 08             	incl   0x8(%ebp)
  102a36:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102a3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a41:	74 06                	je     102a49 <strtol+0x60>
  102a43:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102a47:	75 22                	jne    102a6b <strtol+0x82>
  102a49:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4c:	0f b6 00             	movzbl (%eax),%eax
  102a4f:	3c 30                	cmp    $0x30,%al
  102a51:	75 18                	jne    102a6b <strtol+0x82>
  102a53:	8b 45 08             	mov    0x8(%ebp),%eax
  102a56:	40                   	inc    %eax
  102a57:	0f b6 00             	movzbl (%eax),%eax
  102a5a:	3c 78                	cmp    $0x78,%al
  102a5c:	75 0d                	jne    102a6b <strtol+0x82>
        s += 2, base = 16;
  102a5e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102a62:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102a69:	eb 29                	jmp    102a94 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  102a6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a6f:	75 16                	jne    102a87 <strtol+0x9e>
  102a71:	8b 45 08             	mov    0x8(%ebp),%eax
  102a74:	0f b6 00             	movzbl (%eax),%eax
  102a77:	3c 30                	cmp    $0x30,%al
  102a79:	75 0c                	jne    102a87 <strtol+0x9e>
        s ++, base = 8;
  102a7b:	ff 45 08             	incl   0x8(%ebp)
  102a7e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102a85:	eb 0d                	jmp    102a94 <strtol+0xab>
    }
    else if (base == 0) {
  102a87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a8b:	75 07                	jne    102a94 <strtol+0xab>
        base = 10;
  102a8d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102a94:	8b 45 08             	mov    0x8(%ebp),%eax
  102a97:	0f b6 00             	movzbl (%eax),%eax
  102a9a:	3c 2f                	cmp    $0x2f,%al
  102a9c:	7e 1b                	jle    102ab9 <strtol+0xd0>
  102a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa1:	0f b6 00             	movzbl (%eax),%eax
  102aa4:	3c 39                	cmp    $0x39,%al
  102aa6:	7f 11                	jg     102ab9 <strtol+0xd0>
            dig = *s - '0';
  102aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  102aab:	0f b6 00             	movzbl (%eax),%eax
  102aae:	0f be c0             	movsbl %al,%eax
  102ab1:	83 e8 30             	sub    $0x30,%eax
  102ab4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ab7:	eb 48                	jmp    102b01 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  102abc:	0f b6 00             	movzbl (%eax),%eax
  102abf:	3c 60                	cmp    $0x60,%al
  102ac1:	7e 1b                	jle    102ade <strtol+0xf5>
  102ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac6:	0f b6 00             	movzbl (%eax),%eax
  102ac9:	3c 7a                	cmp    $0x7a,%al
  102acb:	7f 11                	jg     102ade <strtol+0xf5>
            dig = *s - 'a' + 10;
  102acd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad0:	0f b6 00             	movzbl (%eax),%eax
  102ad3:	0f be c0             	movsbl %al,%eax
  102ad6:	83 e8 57             	sub    $0x57,%eax
  102ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102adc:	eb 23                	jmp    102b01 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102ade:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae1:	0f b6 00             	movzbl (%eax),%eax
  102ae4:	3c 40                	cmp    $0x40,%al
  102ae6:	7e 3b                	jle    102b23 <strtol+0x13a>
  102ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  102aeb:	0f b6 00             	movzbl (%eax),%eax
  102aee:	3c 5a                	cmp    $0x5a,%al
  102af0:	7f 31                	jg     102b23 <strtol+0x13a>
            dig = *s - 'A' + 10;
  102af2:	8b 45 08             	mov    0x8(%ebp),%eax
  102af5:	0f b6 00             	movzbl (%eax),%eax
  102af8:	0f be c0             	movsbl %al,%eax
  102afb:	83 e8 37             	sub    $0x37,%eax
  102afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b04:	3b 45 10             	cmp    0x10(%ebp),%eax
  102b07:	7d 19                	jge    102b22 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  102b09:	ff 45 08             	incl   0x8(%ebp)
  102b0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102b0f:	0f af 45 10          	imul   0x10(%ebp),%eax
  102b13:	89 c2                	mov    %eax,%edx
  102b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b18:	01 d0                	add    %edx,%eax
  102b1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102b1d:	e9 72 ff ff ff       	jmp    102a94 <strtol+0xab>
            break;
  102b22:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102b23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102b27:	74 08                	je     102b31 <strtol+0x148>
        *endptr = (char *) s;
  102b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b2c:	8b 55 08             	mov    0x8(%ebp),%edx
  102b2f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102b31:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102b35:	74 07                	je     102b3e <strtol+0x155>
  102b37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102b3a:	f7 d8                	neg    %eax
  102b3c:	eb 03                	jmp    102b41 <strtol+0x158>
  102b3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102b41:	c9                   	leave  
  102b42:	c3                   	ret    

00102b43 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102b43:	f3 0f 1e fb          	endbr32 
  102b47:	55                   	push   %ebp
  102b48:	89 e5                	mov    %esp,%ebp
  102b4a:	57                   	push   %edi
  102b4b:	83 ec 24             	sub    $0x24,%esp
  102b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b51:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102b54:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  102b58:	8b 45 08             	mov    0x8(%ebp),%eax
  102b5b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  102b5e:	88 55 f7             	mov    %dl,-0x9(%ebp)
  102b61:	8b 45 10             	mov    0x10(%ebp),%eax
  102b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102b67:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102b6a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102b6e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102b71:	89 d7                	mov    %edx,%edi
  102b73:	f3 aa                	rep stos %al,%es:(%edi)
  102b75:	89 fa                	mov    %edi,%edx
  102b77:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102b7a:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102b7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102b80:	83 c4 24             	add    $0x24,%esp
  102b83:	5f                   	pop    %edi
  102b84:	5d                   	pop    %ebp
  102b85:	c3                   	ret    

00102b86 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102b86:	f3 0f 1e fb          	endbr32 
  102b8a:	55                   	push   %ebp
  102b8b:	89 e5                	mov    %esp,%ebp
  102b8d:	57                   	push   %edi
  102b8e:	56                   	push   %esi
  102b8f:	53                   	push   %ebx
  102b90:	83 ec 30             	sub    $0x30,%esp
  102b93:	8b 45 08             	mov    0x8(%ebp),%eax
  102b96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b99:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102b9f:	8b 45 10             	mov    0x10(%ebp),%eax
  102ba2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ba8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102bab:	73 42                	jae    102bef <memmove+0x69>
  102bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102bb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102bb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102bb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bbc:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102bbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bc2:	c1 e8 02             	shr    $0x2,%eax
  102bc5:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102bc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102bca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102bcd:	89 d7                	mov    %edx,%edi
  102bcf:	89 c6                	mov    %eax,%esi
  102bd1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102bd3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102bd6:	83 e1 03             	and    $0x3,%ecx
  102bd9:	74 02                	je     102bdd <memmove+0x57>
  102bdb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102bdd:	89 f0                	mov    %esi,%eax
  102bdf:	89 fa                	mov    %edi,%edx
  102be1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102be4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102be7:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102bea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  102bed:	eb 36                	jmp    102c25 <memmove+0x9f>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102bef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bf2:	8d 50 ff             	lea    -0x1(%eax),%edx
  102bf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102bf8:	01 c2                	add    %eax,%edx
  102bfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bfd:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c03:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102c06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c09:	89 c1                	mov    %eax,%ecx
  102c0b:	89 d8                	mov    %ebx,%eax
  102c0d:	89 d6                	mov    %edx,%esi
  102c0f:	89 c7                	mov    %eax,%edi
  102c11:	fd                   	std    
  102c12:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102c14:	fc                   	cld    
  102c15:	89 f8                	mov    %edi,%eax
  102c17:	89 f2                	mov    %esi,%edx
  102c19:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102c1c:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102c1f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102c25:	83 c4 30             	add    $0x30,%esp
  102c28:	5b                   	pop    %ebx
  102c29:	5e                   	pop    %esi
  102c2a:	5f                   	pop    %edi
  102c2b:	5d                   	pop    %ebp
  102c2c:	c3                   	ret    

00102c2d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102c2d:	f3 0f 1e fb          	endbr32 
  102c31:	55                   	push   %ebp
  102c32:	89 e5                	mov    %esp,%ebp
  102c34:	57                   	push   %edi
  102c35:	56                   	push   %esi
  102c36:	83 ec 20             	sub    $0x20,%esp
  102c39:	8b 45 08             	mov    0x8(%ebp),%eax
  102c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c45:	8b 45 10             	mov    0x10(%ebp),%eax
  102c48:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c4e:	c1 e8 02             	shr    $0x2,%eax
  102c51:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102c53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c59:	89 d7                	mov    %edx,%edi
  102c5b:	89 c6                	mov    %eax,%esi
  102c5d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102c5f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102c62:	83 e1 03             	and    $0x3,%ecx
  102c65:	74 02                	je     102c69 <memcpy+0x3c>
  102c67:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102c69:	89 f0                	mov    %esi,%eax
  102c6b:	89 fa                	mov    %edi,%edx
  102c6d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102c70:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102c73:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  102c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102c79:	83 c4 20             	add    $0x20,%esp
  102c7c:	5e                   	pop    %esi
  102c7d:	5f                   	pop    %edi
  102c7e:	5d                   	pop    %ebp
  102c7f:	c3                   	ret    

00102c80 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102c80:	f3 0f 1e fb          	endbr32 
  102c84:	55                   	push   %ebp
  102c85:	89 e5                	mov    %esp,%ebp
  102c87:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c93:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102c96:	eb 2e                	jmp    102cc6 <memcmp+0x46>
        if (*s1 != *s2) {
  102c98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c9b:	0f b6 10             	movzbl (%eax),%edx
  102c9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ca1:	0f b6 00             	movzbl (%eax),%eax
  102ca4:	38 c2                	cmp    %al,%dl
  102ca6:	74 18                	je     102cc0 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102ca8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102cab:	0f b6 00             	movzbl (%eax),%eax
  102cae:	0f b6 d0             	movzbl %al,%edx
  102cb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102cb4:	0f b6 00             	movzbl (%eax),%eax
  102cb7:	0f b6 c0             	movzbl %al,%eax
  102cba:	29 c2                	sub    %eax,%edx
  102cbc:	89 d0                	mov    %edx,%eax
  102cbe:	eb 18                	jmp    102cd8 <memcmp+0x58>
        }
        s1 ++, s2 ++;
  102cc0:	ff 45 fc             	incl   -0x4(%ebp)
  102cc3:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  102cc6:	8b 45 10             	mov    0x10(%ebp),%eax
  102cc9:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ccc:	89 55 10             	mov    %edx,0x10(%ebp)
  102ccf:	85 c0                	test   %eax,%eax
  102cd1:	75 c5                	jne    102c98 <memcmp+0x18>
    }
    return 0;
  102cd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102cd8:	c9                   	leave  
  102cd9:	c3                   	ret    

00102cda <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102cda:	f3 0f 1e fb          	endbr32 
  102cde:	55                   	push   %ebp
  102cdf:	89 e5                	mov    %esp,%ebp
  102ce1:	83 ec 58             	sub    $0x58,%esp
  102ce4:	8b 45 10             	mov    0x10(%ebp),%eax
  102ce7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102cea:	8b 45 14             	mov    0x14(%ebp),%eax
  102ced:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102cf0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102cf3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102cf6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102cf9:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102cfc:	8b 45 18             	mov    0x18(%ebp),%eax
  102cff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102d02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102d08:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102d0b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102d18:	74 1c                	je     102d36 <printnum+0x5c>
  102d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  102d22:	f7 75 e4             	divl   -0x1c(%ebp)
  102d25:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d2b:	ba 00 00 00 00       	mov    $0x0,%edx
  102d30:	f7 75 e4             	divl   -0x1c(%ebp)
  102d33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d3c:	f7 75 e4             	divl   -0x1c(%ebp)
  102d3f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102d42:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102d45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102d4b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d4e:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102d51:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d54:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102d57:	8b 45 18             	mov    0x18(%ebp),%eax
  102d5a:	ba 00 00 00 00       	mov    $0x0,%edx
  102d5f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  102d62:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102d65:	19 d1                	sbb    %edx,%ecx
  102d67:	72 4c                	jb     102db5 <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  102d69:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102d6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  102d6f:	8b 45 20             	mov    0x20(%ebp),%eax
  102d72:	89 44 24 18          	mov    %eax,0x18(%esp)
  102d76:	89 54 24 14          	mov    %edx,0x14(%esp)
  102d7a:	8b 45 18             	mov    0x18(%ebp),%eax
  102d7d:	89 44 24 10          	mov    %eax,0x10(%esp)
  102d81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d84:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102d87:	89 44 24 08          	mov    %eax,0x8(%esp)
  102d8b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d92:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d96:	8b 45 08             	mov    0x8(%ebp),%eax
  102d99:	89 04 24             	mov    %eax,(%esp)
  102d9c:	e8 39 ff ff ff       	call   102cda <printnum>
  102da1:	eb 1b                	jmp    102dbe <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102da6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102daa:	8b 45 20             	mov    0x20(%ebp),%eax
  102dad:	89 04 24             	mov    %eax,(%esp)
  102db0:	8b 45 08             	mov    0x8(%ebp),%eax
  102db3:	ff d0                	call   *%eax
        while (-- width > 0)
  102db5:	ff 4d 1c             	decl   0x1c(%ebp)
  102db8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102dbc:	7f e5                	jg     102da3 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102dbe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102dc1:	05 f0 3a 10 00       	add    $0x103af0,%eax
  102dc6:	0f b6 00             	movzbl (%eax),%eax
  102dc9:	0f be c0             	movsbl %al,%eax
  102dcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  102dcf:	89 54 24 04          	mov    %edx,0x4(%esp)
  102dd3:	89 04 24             	mov    %eax,(%esp)
  102dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd9:	ff d0                	call   *%eax
}
  102ddb:	90                   	nop
  102ddc:	c9                   	leave  
  102ddd:	c3                   	ret    

00102dde <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102dde:	f3 0f 1e fb          	endbr32 
  102de2:	55                   	push   %ebp
  102de3:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102de5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102de9:	7e 14                	jle    102dff <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  102deb:	8b 45 08             	mov    0x8(%ebp),%eax
  102dee:	8b 00                	mov    (%eax),%eax
  102df0:	8d 48 08             	lea    0x8(%eax),%ecx
  102df3:	8b 55 08             	mov    0x8(%ebp),%edx
  102df6:	89 0a                	mov    %ecx,(%edx)
  102df8:	8b 50 04             	mov    0x4(%eax),%edx
  102dfb:	8b 00                	mov    (%eax),%eax
  102dfd:	eb 30                	jmp    102e2f <getuint+0x51>
    }
    else if (lflag) {
  102dff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102e03:	74 16                	je     102e1b <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  102e05:	8b 45 08             	mov    0x8(%ebp),%eax
  102e08:	8b 00                	mov    (%eax),%eax
  102e0a:	8d 48 04             	lea    0x4(%eax),%ecx
  102e0d:	8b 55 08             	mov    0x8(%ebp),%edx
  102e10:	89 0a                	mov    %ecx,(%edx)
  102e12:	8b 00                	mov    (%eax),%eax
  102e14:	ba 00 00 00 00       	mov    $0x0,%edx
  102e19:	eb 14                	jmp    102e2f <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  102e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1e:	8b 00                	mov    (%eax),%eax
  102e20:	8d 48 04             	lea    0x4(%eax),%ecx
  102e23:	8b 55 08             	mov    0x8(%ebp),%edx
  102e26:	89 0a                	mov    %ecx,(%edx)
  102e28:	8b 00                	mov    (%eax),%eax
  102e2a:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102e2f:	5d                   	pop    %ebp
  102e30:	c3                   	ret    

00102e31 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102e31:	f3 0f 1e fb          	endbr32 
  102e35:	55                   	push   %ebp
  102e36:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102e38:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102e3c:	7e 14                	jle    102e52 <getint+0x21>
        return va_arg(*ap, long long);
  102e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e41:	8b 00                	mov    (%eax),%eax
  102e43:	8d 48 08             	lea    0x8(%eax),%ecx
  102e46:	8b 55 08             	mov    0x8(%ebp),%edx
  102e49:	89 0a                	mov    %ecx,(%edx)
  102e4b:	8b 50 04             	mov    0x4(%eax),%edx
  102e4e:	8b 00                	mov    (%eax),%eax
  102e50:	eb 28                	jmp    102e7a <getint+0x49>
    }
    else if (lflag) {
  102e52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102e56:	74 12                	je     102e6a <getint+0x39>
        return va_arg(*ap, long);
  102e58:	8b 45 08             	mov    0x8(%ebp),%eax
  102e5b:	8b 00                	mov    (%eax),%eax
  102e5d:	8d 48 04             	lea    0x4(%eax),%ecx
  102e60:	8b 55 08             	mov    0x8(%ebp),%edx
  102e63:	89 0a                	mov    %ecx,(%edx)
  102e65:	8b 00                	mov    (%eax),%eax
  102e67:	99                   	cltd   
  102e68:	eb 10                	jmp    102e7a <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  102e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6d:	8b 00                	mov    (%eax),%eax
  102e6f:	8d 48 04             	lea    0x4(%eax),%ecx
  102e72:	8b 55 08             	mov    0x8(%ebp),%edx
  102e75:	89 0a                	mov    %ecx,(%edx)
  102e77:	8b 00                	mov    (%eax),%eax
  102e79:	99                   	cltd   
    }
}
  102e7a:	5d                   	pop    %ebp
  102e7b:	c3                   	ret    

00102e7c <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102e7c:	f3 0f 1e fb          	endbr32 
  102e80:	55                   	push   %ebp
  102e81:	89 e5                	mov    %esp,%ebp
  102e83:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102e86:	8d 45 14             	lea    0x14(%ebp),%eax
  102e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102e93:	8b 45 10             	mov    0x10(%ebp),%eax
  102e96:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea4:	89 04 24             	mov    %eax,(%esp)
  102ea7:	e8 03 00 00 00       	call   102eaf <vprintfmt>
    va_end(ap);
}
  102eac:	90                   	nop
  102ead:	c9                   	leave  
  102eae:	c3                   	ret    

00102eaf <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102eaf:	f3 0f 1e fb          	endbr32 
  102eb3:	55                   	push   %ebp
  102eb4:	89 e5                	mov    %esp,%ebp
  102eb6:	56                   	push   %esi
  102eb7:	53                   	push   %ebx
  102eb8:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102ebb:	eb 17                	jmp    102ed4 <vprintfmt+0x25>
            if (ch == '\0') {
  102ebd:	85 db                	test   %ebx,%ebx
  102ebf:	0f 84 c0 03 00 00    	je     103285 <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  102ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ec8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ecc:	89 1c 24             	mov    %ebx,(%esp)
  102ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed2:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  102ed7:	8d 50 01             	lea    0x1(%eax),%edx
  102eda:	89 55 10             	mov    %edx,0x10(%ebp)
  102edd:	0f b6 00             	movzbl (%eax),%eax
  102ee0:	0f b6 d8             	movzbl %al,%ebx
  102ee3:	83 fb 25             	cmp    $0x25,%ebx
  102ee6:	75 d5                	jne    102ebd <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  102ee8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102eec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102ef3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ef6:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102ef9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f03:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102f06:	8b 45 10             	mov    0x10(%ebp),%eax
  102f09:	8d 50 01             	lea    0x1(%eax),%edx
  102f0c:	89 55 10             	mov    %edx,0x10(%ebp)
  102f0f:	0f b6 00             	movzbl (%eax),%eax
  102f12:	0f b6 d8             	movzbl %al,%ebx
  102f15:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102f18:	83 f8 55             	cmp    $0x55,%eax
  102f1b:	0f 87 38 03 00 00    	ja     103259 <vprintfmt+0x3aa>
  102f21:	8b 04 85 14 3b 10 00 	mov    0x103b14(,%eax,4),%eax
  102f28:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102f2b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102f2f:	eb d5                	jmp    102f06 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102f31:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102f35:	eb cf                	jmp    102f06 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102f37:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102f3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102f41:	89 d0                	mov    %edx,%eax
  102f43:	c1 e0 02             	shl    $0x2,%eax
  102f46:	01 d0                	add    %edx,%eax
  102f48:	01 c0                	add    %eax,%eax
  102f4a:	01 d8                	add    %ebx,%eax
  102f4c:	83 e8 30             	sub    $0x30,%eax
  102f4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102f52:	8b 45 10             	mov    0x10(%ebp),%eax
  102f55:	0f b6 00             	movzbl (%eax),%eax
  102f58:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102f5b:	83 fb 2f             	cmp    $0x2f,%ebx
  102f5e:	7e 38                	jle    102f98 <vprintfmt+0xe9>
  102f60:	83 fb 39             	cmp    $0x39,%ebx
  102f63:	7f 33                	jg     102f98 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  102f65:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  102f68:	eb d4                	jmp    102f3e <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  102f6d:	8d 50 04             	lea    0x4(%eax),%edx
  102f70:	89 55 14             	mov    %edx,0x14(%ebp)
  102f73:	8b 00                	mov    (%eax),%eax
  102f75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102f78:	eb 1f                	jmp    102f99 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  102f7a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f7e:	79 86                	jns    102f06 <vprintfmt+0x57>
                width = 0;
  102f80:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102f87:	e9 7a ff ff ff       	jmp    102f06 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  102f8c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102f93:	e9 6e ff ff ff       	jmp    102f06 <vprintfmt+0x57>
            goto process_precision;
  102f98:	90                   	nop

        process_precision:
            if (width < 0)
  102f99:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f9d:	0f 89 63 ff ff ff    	jns    102f06 <vprintfmt+0x57>
                width = precision, precision = -1;
  102fa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102fa6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102fa9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102fb0:	e9 51 ff ff ff       	jmp    102f06 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102fb5:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  102fb8:	e9 49 ff ff ff       	jmp    102f06 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102fbd:	8b 45 14             	mov    0x14(%ebp),%eax
  102fc0:	8d 50 04             	lea    0x4(%eax),%edx
  102fc3:	89 55 14             	mov    %edx,0x14(%ebp)
  102fc6:	8b 00                	mov    (%eax),%eax
  102fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  102fcb:	89 54 24 04          	mov    %edx,0x4(%esp)
  102fcf:	89 04 24             	mov    %eax,(%esp)
  102fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  102fd5:	ff d0                	call   *%eax
            break;
  102fd7:	e9 a4 02 00 00       	jmp    103280 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102fdc:	8b 45 14             	mov    0x14(%ebp),%eax
  102fdf:	8d 50 04             	lea    0x4(%eax),%edx
  102fe2:	89 55 14             	mov    %edx,0x14(%ebp)
  102fe5:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102fe7:	85 db                	test   %ebx,%ebx
  102fe9:	79 02                	jns    102fed <vprintfmt+0x13e>
                err = -err;
  102feb:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102fed:	83 fb 06             	cmp    $0x6,%ebx
  102ff0:	7f 0b                	jg     102ffd <vprintfmt+0x14e>
  102ff2:	8b 34 9d d4 3a 10 00 	mov    0x103ad4(,%ebx,4),%esi
  102ff9:	85 f6                	test   %esi,%esi
  102ffb:	75 23                	jne    103020 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  102ffd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  103001:	c7 44 24 08 01 3b 10 	movl   $0x103b01,0x8(%esp)
  103008:	00 
  103009:	8b 45 0c             	mov    0xc(%ebp),%eax
  10300c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103010:	8b 45 08             	mov    0x8(%ebp),%eax
  103013:	89 04 24             	mov    %eax,(%esp)
  103016:	e8 61 fe ff ff       	call   102e7c <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10301b:	e9 60 02 00 00       	jmp    103280 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  103020:	89 74 24 0c          	mov    %esi,0xc(%esp)
  103024:	c7 44 24 08 0a 3b 10 	movl   $0x103b0a,0x8(%esp)
  10302b:	00 
  10302c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10302f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103033:	8b 45 08             	mov    0x8(%ebp),%eax
  103036:	89 04 24             	mov    %eax,(%esp)
  103039:	e8 3e fe ff ff       	call   102e7c <printfmt>
            break;
  10303e:	e9 3d 02 00 00       	jmp    103280 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  103043:	8b 45 14             	mov    0x14(%ebp),%eax
  103046:	8d 50 04             	lea    0x4(%eax),%edx
  103049:	89 55 14             	mov    %edx,0x14(%ebp)
  10304c:	8b 30                	mov    (%eax),%esi
  10304e:	85 f6                	test   %esi,%esi
  103050:	75 05                	jne    103057 <vprintfmt+0x1a8>
                p = "(null)";
  103052:	be 0d 3b 10 00       	mov    $0x103b0d,%esi
            }
            if (width > 0 && padc != '-') {
  103057:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10305b:	7e 76                	jle    1030d3 <vprintfmt+0x224>
  10305d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  103061:	74 70                	je     1030d3 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  103063:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103066:	89 44 24 04          	mov    %eax,0x4(%esp)
  10306a:	89 34 24             	mov    %esi,(%esp)
  10306d:	e8 ba f7 ff ff       	call   10282c <strnlen>
  103072:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103075:	29 c2                	sub    %eax,%edx
  103077:	89 d0                	mov    %edx,%eax
  103079:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10307c:	eb 16                	jmp    103094 <vprintfmt+0x1e5>
                    putch(padc, putdat);
  10307e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  103082:	8b 55 0c             	mov    0xc(%ebp),%edx
  103085:	89 54 24 04          	mov    %edx,0x4(%esp)
  103089:	89 04 24             	mov    %eax,(%esp)
  10308c:	8b 45 08             	mov    0x8(%ebp),%eax
  10308f:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  103091:	ff 4d e8             	decl   -0x18(%ebp)
  103094:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103098:	7f e4                	jg     10307e <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10309a:	eb 37                	jmp    1030d3 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  10309c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1030a0:	74 1f                	je     1030c1 <vprintfmt+0x212>
  1030a2:	83 fb 1f             	cmp    $0x1f,%ebx
  1030a5:	7e 05                	jle    1030ac <vprintfmt+0x1fd>
  1030a7:	83 fb 7e             	cmp    $0x7e,%ebx
  1030aa:	7e 15                	jle    1030c1 <vprintfmt+0x212>
                    putch('?', putdat);
  1030ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030b3:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1030bd:	ff d0                	call   *%eax
  1030bf:	eb 0f                	jmp    1030d0 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  1030c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030c8:	89 1c 24             	mov    %ebx,(%esp)
  1030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ce:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1030d0:	ff 4d e8             	decl   -0x18(%ebp)
  1030d3:	89 f0                	mov    %esi,%eax
  1030d5:	8d 70 01             	lea    0x1(%eax),%esi
  1030d8:	0f b6 00             	movzbl (%eax),%eax
  1030db:	0f be d8             	movsbl %al,%ebx
  1030de:	85 db                	test   %ebx,%ebx
  1030e0:	74 27                	je     103109 <vprintfmt+0x25a>
  1030e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1030e6:	78 b4                	js     10309c <vprintfmt+0x1ed>
  1030e8:	ff 4d e4             	decl   -0x1c(%ebp)
  1030eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1030ef:	79 ab                	jns    10309c <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  1030f1:	eb 16                	jmp    103109 <vprintfmt+0x25a>
                putch(' ', putdat);
  1030f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030fa:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  103101:	8b 45 08             	mov    0x8(%ebp),%eax
  103104:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  103106:	ff 4d e8             	decl   -0x18(%ebp)
  103109:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10310d:	7f e4                	jg     1030f3 <vprintfmt+0x244>
            }
            break;
  10310f:	e9 6c 01 00 00       	jmp    103280 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103114:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103117:	89 44 24 04          	mov    %eax,0x4(%esp)
  10311b:	8d 45 14             	lea    0x14(%ebp),%eax
  10311e:	89 04 24             	mov    %eax,(%esp)
  103121:	e8 0b fd ff ff       	call   102e31 <getint>
  103126:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103129:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10312c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10312f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103132:	85 d2                	test   %edx,%edx
  103134:	79 26                	jns    10315c <vprintfmt+0x2ad>
                putch('-', putdat);
  103136:	8b 45 0c             	mov    0xc(%ebp),%eax
  103139:	89 44 24 04          	mov    %eax,0x4(%esp)
  10313d:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  103144:	8b 45 08             	mov    0x8(%ebp),%eax
  103147:	ff d0                	call   *%eax
                num = -(long long)num;
  103149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10314c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10314f:	f7 d8                	neg    %eax
  103151:	83 d2 00             	adc    $0x0,%edx
  103154:	f7 da                	neg    %edx
  103156:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103159:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10315c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103163:	e9 a8 00 00 00       	jmp    103210 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103168:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10316b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10316f:	8d 45 14             	lea    0x14(%ebp),%eax
  103172:	89 04 24             	mov    %eax,(%esp)
  103175:	e8 64 fc ff ff       	call   102dde <getuint>
  10317a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10317d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  103180:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103187:	e9 84 00 00 00       	jmp    103210 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10318c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10318f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103193:	8d 45 14             	lea    0x14(%ebp),%eax
  103196:	89 04 24             	mov    %eax,(%esp)
  103199:	e8 40 fc ff ff       	call   102dde <getuint>
  10319e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1031a4:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1031ab:	eb 63                	jmp    103210 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  1031ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031b4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1031bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1031be:	ff d0                	call   *%eax
            putch('x', putdat);
  1031c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031c7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  1031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d1:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1031d3:	8b 45 14             	mov    0x14(%ebp),%eax
  1031d6:	8d 50 04             	lea    0x4(%eax),%edx
  1031d9:	89 55 14             	mov    %edx,0x14(%ebp)
  1031dc:	8b 00                	mov    (%eax),%eax
  1031de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1031e8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1031ef:	eb 1f                	jmp    103210 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1031f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031f8:	8d 45 14             	lea    0x14(%ebp),%eax
  1031fb:	89 04 24             	mov    %eax,(%esp)
  1031fe:	e8 db fb ff ff       	call   102dde <getuint>
  103203:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103206:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103209:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103210:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103214:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103217:	89 54 24 18          	mov    %edx,0x18(%esp)
  10321b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10321e:	89 54 24 14          	mov    %edx,0x14(%esp)
  103222:	89 44 24 10          	mov    %eax,0x10(%esp)
  103226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103229:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10322c:	89 44 24 08          	mov    %eax,0x8(%esp)
  103230:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103234:	8b 45 0c             	mov    0xc(%ebp),%eax
  103237:	89 44 24 04          	mov    %eax,0x4(%esp)
  10323b:	8b 45 08             	mov    0x8(%ebp),%eax
  10323e:	89 04 24             	mov    %eax,(%esp)
  103241:	e8 94 fa ff ff       	call   102cda <printnum>
            break;
  103246:	eb 38                	jmp    103280 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103248:	8b 45 0c             	mov    0xc(%ebp),%eax
  10324b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10324f:	89 1c 24             	mov    %ebx,(%esp)
  103252:	8b 45 08             	mov    0x8(%ebp),%eax
  103255:	ff d0                	call   *%eax
            break;
  103257:	eb 27                	jmp    103280 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103259:	8b 45 0c             	mov    0xc(%ebp),%eax
  10325c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103260:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  103267:	8b 45 08             	mov    0x8(%ebp),%eax
  10326a:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  10326c:	ff 4d 10             	decl   0x10(%ebp)
  10326f:	eb 03                	jmp    103274 <vprintfmt+0x3c5>
  103271:	ff 4d 10             	decl   0x10(%ebp)
  103274:	8b 45 10             	mov    0x10(%ebp),%eax
  103277:	48                   	dec    %eax
  103278:	0f b6 00             	movzbl (%eax),%eax
  10327b:	3c 25                	cmp    $0x25,%al
  10327d:	75 f2                	jne    103271 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  10327f:	90                   	nop
    while (1) {
  103280:	e9 36 fc ff ff       	jmp    102ebb <vprintfmt+0xc>
                return;
  103285:	90                   	nop
        }
    }
}
  103286:	83 c4 40             	add    $0x40,%esp
  103289:	5b                   	pop    %ebx
  10328a:	5e                   	pop    %esi
  10328b:	5d                   	pop    %ebp
  10328c:	c3                   	ret    

0010328d <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10328d:	f3 0f 1e fb          	endbr32 
  103291:	55                   	push   %ebp
  103292:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103294:	8b 45 0c             	mov    0xc(%ebp),%eax
  103297:	8b 40 08             	mov    0x8(%eax),%eax
  10329a:	8d 50 01             	lea    0x1(%eax),%edx
  10329d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032a0:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1032a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032a6:	8b 10                	mov    (%eax),%edx
  1032a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032ab:	8b 40 04             	mov    0x4(%eax),%eax
  1032ae:	39 c2                	cmp    %eax,%edx
  1032b0:	73 12                	jae    1032c4 <sprintputch+0x37>
        *b->buf ++ = ch;
  1032b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032b5:	8b 00                	mov    (%eax),%eax
  1032b7:	8d 48 01             	lea    0x1(%eax),%ecx
  1032ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  1032bd:	89 0a                	mov    %ecx,(%edx)
  1032bf:	8b 55 08             	mov    0x8(%ebp),%edx
  1032c2:	88 10                	mov    %dl,(%eax)
    }
}
  1032c4:	90                   	nop
  1032c5:	5d                   	pop    %ebp
  1032c6:	c3                   	ret    

001032c7 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1032c7:	f3 0f 1e fb          	endbr32 
  1032cb:	55                   	push   %ebp
  1032cc:	89 e5                	mov    %esp,%ebp
  1032ce:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1032d1:	8d 45 14             	lea    0x14(%ebp),%eax
  1032d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1032d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1032de:	8b 45 10             	mov    0x10(%ebp),%eax
  1032e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1032e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ef:	89 04 24             	mov    %eax,(%esp)
  1032f2:	e8 08 00 00 00       	call   1032ff <vsnprintf>
  1032f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1032fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1032fd:	c9                   	leave  
  1032fe:	c3                   	ret    

001032ff <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1032ff:	f3 0f 1e fb          	endbr32 
  103303:	55                   	push   %ebp
  103304:	89 e5                	mov    %esp,%ebp
  103306:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103309:	8b 45 08             	mov    0x8(%ebp),%eax
  10330c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10330f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103312:	8d 50 ff             	lea    -0x1(%eax),%edx
  103315:	8b 45 08             	mov    0x8(%ebp),%eax
  103318:	01 d0                	add    %edx,%eax
  10331a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10331d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103324:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103328:	74 0a                	je     103334 <vsnprintf+0x35>
  10332a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10332d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103330:	39 c2                	cmp    %eax,%edx
  103332:	76 07                	jbe    10333b <vsnprintf+0x3c>
        return -E_INVAL;
  103334:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103339:	eb 2a                	jmp    103365 <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10333b:	8b 45 14             	mov    0x14(%ebp),%eax
  10333e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103342:	8b 45 10             	mov    0x10(%ebp),%eax
  103345:	89 44 24 08          	mov    %eax,0x8(%esp)
  103349:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10334c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103350:	c7 04 24 8d 32 10 00 	movl   $0x10328d,(%esp)
  103357:	e8 53 fb ff ff       	call   102eaf <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10335c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10335f:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103362:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103365:	c9                   	leave  
  103366:	c3                   	ret    
