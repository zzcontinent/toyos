
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
void kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

void kern_init(void)
{
  100000:	f3 0f 1e fb          	endbr32 
  100004:	55                   	push   %ebp
  100005:	89 e5                	mov    %esp,%ebp
  100007:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10000a:	b8 80 0d 11 00       	mov    $0x110d80,%eax
  10000f:	2d 16 fa 10 00       	sub    $0x10fa16,%eax
  100014:	83 ec 04             	sub    $0x4,%esp
  100017:	50                   	push   %eax
  100018:	6a 00                	push   $0x0
  10001a:	68 16 fa 10 00       	push   $0x10fa16
  10001f:	e8 ec 2e 00 00       	call   102f10 <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init(); // init the console
  100027:	e8 09 16 00 00       	call   101635 <cons_init>

    const char* message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 e0 36 10 00 	movl   $0x1036e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 fc 36 10 00       	push   $0x1036fc
  10003e:	e8 32 02 00 00       	call   100275 <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 e6 08 00 00       	call   100931 <print_kerninfo>

    grade_backtrace();
  10004b:	e8 85 00 00 00       	call   1000d5 <grade_backtrace>

    pmm_init(); // init physical memory management
  100050:	e8 59 2b 00 00       	call   102bae <pmm_init>

    pic_init(); // init interrupt controller
  100055:	e8 34 17 00 00       	call   10178e <pic_init>
    idt_init(); // init interrupt descriptor table
  10005a:	e8 b5 18 00 00       	call   101914 <idt_init>

    clock_init();  // init clock interrupt
  10005f:	e8 56 0d 00 00       	call   100dba <clock_init>
    intr_enable(); // enable irq interrupt
  100064:	e8 74 18 00 00       	call   1018dd <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100069:	e8 6c 01 00 00       	call   1001da <lab1_switch_test>

    /* do nothing */
    while (1)
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
	;
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3)
{
  100070:	f3 0f 1e fb          	endbr32 
  100074:	55                   	push   %ebp
  100075:	89 e5                	mov    %esp,%ebp
  100077:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  10007a:	83 ec 04             	sub    $0x4,%esp
  10007d:	6a 00                	push   $0x0
  10007f:	6a 00                	push   $0x0
  100081:	6a 00                	push   $0x0
  100083:	e8 1c 0d 00 00       	call   100da4 <mon_backtrace>
  100088:	83 c4 10             	add    $0x10,%esp
}
  10008b:	90                   	nop
  10008c:	c9                   	leave  
  10008d:	c3                   	ret    

0010008e <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1)
{
  10008e:	f3 0f 1e fb          	endbr32 
  100092:	55                   	push   %ebp
  100093:	89 e5                	mov    %esp,%ebp
  100095:	53                   	push   %ebx
  100096:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  100099:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  10009c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10009f:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a5:	51                   	push   %ecx
  1000a6:	52                   	push   %edx
  1000a7:	53                   	push   %ebx
  1000a8:	50                   	push   %eax
  1000a9:	e8 c2 ff ff ff       	call   100070 <grade_backtrace2>
  1000ae:	83 c4 10             	add    $0x10,%esp
}
  1000b1:	90                   	nop
  1000b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000b5:	c9                   	leave  
  1000b6:	c3                   	ret    

001000b7 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2)
{
  1000b7:	f3 0f 1e fb          	endbr32 
  1000bb:	55                   	push   %ebp
  1000bc:	89 e5                	mov    %esp,%ebp
  1000be:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000c1:	83 ec 08             	sub    $0x8,%esp
  1000c4:	ff 75 10             	pushl  0x10(%ebp)
  1000c7:	ff 75 08             	pushl  0x8(%ebp)
  1000ca:	e8 bf ff ff ff       	call   10008e <grade_backtrace1>
  1000cf:	83 c4 10             	add    $0x10,%esp
}
  1000d2:	90                   	nop
  1000d3:	c9                   	leave  
  1000d4:	c3                   	ret    

001000d5 <grade_backtrace>:

void grade_backtrace(void)
{
  1000d5:	f3 0f 1e fb          	endbr32 
  1000d9:	55                   	push   %ebp
  1000da:	89 e5                	mov    %esp,%ebp
  1000dc:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000df:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e4:	83 ec 04             	sub    $0x4,%esp
  1000e7:	68 00 00 ff ff       	push   $0xffff0000
  1000ec:	50                   	push   %eax
  1000ed:	6a 00                	push   $0x0
  1000ef:	e8 c3 ff ff ff       	call   1000b7 <grade_backtrace0>
  1000f4:	83 c4 10             	add    $0x10,%esp
}
  1000f7:	90                   	nop
  1000f8:	c9                   	leave  
  1000f9:	c3                   	ret    

001000fa <lab1_print_cur_status>:

static void
lab1_print_cur_status(void)
{
  1000fa:	f3 0f 1e fb          	endbr32 
  1000fe:	55                   	push   %ebp
  1000ff:	89 e5                	mov    %esp,%ebp
  100101:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile(
  100104:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100107:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010a:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
	"mov %%cs, %0;"
	"mov %%ds, %1;"
	"mov %%es, %2;"
	"mov %%ss, %3;"
	: "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100110:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100114:	0f b7 c0             	movzwl %ax,%eax
  100117:	83 e0 03             	and    $0x3,%eax
  10011a:	89 c2                	mov    %eax,%edx
  10011c:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100121:	83 ec 04             	sub    $0x4,%esp
  100124:	52                   	push   %edx
  100125:	50                   	push   %eax
  100126:	68 01 37 10 00       	push   $0x103701
  10012b:	e8 45 01 00 00       	call   100275 <cprintf>
  100130:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  100133:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100137:	0f b7 d0             	movzwl %ax,%edx
  10013a:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10013f:	83 ec 04             	sub    $0x4,%esp
  100142:	52                   	push   %edx
  100143:	50                   	push   %eax
  100144:	68 0f 37 10 00       	push   $0x10370f
  100149:	e8 27 01 00 00       	call   100275 <cprintf>
  10014e:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100151:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100155:	0f b7 d0             	movzwl %ax,%edx
  100158:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10015d:	83 ec 04             	sub    $0x4,%esp
  100160:	52                   	push   %edx
  100161:	50                   	push   %eax
  100162:	68 1d 37 10 00       	push   $0x10371d
  100167:	e8 09 01 00 00       	call   100275 <cprintf>
  10016c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  10016f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100173:	0f b7 d0             	movzwl %ax,%edx
  100176:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10017b:	83 ec 04             	sub    $0x4,%esp
  10017e:	52                   	push   %edx
  10017f:	50                   	push   %eax
  100180:	68 2b 37 10 00       	push   $0x10372b
  100185:	e8 eb 00 00 00       	call   100275 <cprintf>
  10018a:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  10018d:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100191:	0f b7 d0             	movzwl %ax,%edx
  100194:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100199:	83 ec 04             	sub    $0x4,%esp
  10019c:	52                   	push   %edx
  10019d:	50                   	push   %eax
  10019e:	68 39 37 10 00       	push   $0x103739
  1001a3:	e8 cd 00 00 00       	call   100275 <cprintf>
  1001a8:	83 c4 10             	add    $0x10,%esp
    round++;
  1001ab:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001b0:	83 c0 01             	add    $0x1,%eax
  1001b3:	a3 20 fa 10 00       	mov    %eax,0x10fa20
}
  1001b8:	90                   	nop
  1001b9:	c9                   	leave  
  1001ba:	c3                   	ret    

001001bb <lab1_switch_to_user>:

static void
lab1_switch_to_user(void)
{
  1001bb:	f3 0f 1e fb          	endbr32 
  1001bf:	55                   	push   %ebp
  1001c0:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile(
  1001c2:	83 ec 08             	sub    $0x8,%esp
  1001c5:	cd 78                	int    $0x78
  1001c7:	89 ec                	mov    %ebp,%esp
	"sub $0x8, %%esp \n"
	"int %0 \n"
	"movl %%ebp, %%esp"
	:
	: "i"(T_SWITCH_TOU));
}
  1001c9:	90                   	nop
  1001ca:	5d                   	pop    %ebp
  1001cb:	c3                   	ret    

001001cc <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void)
{
  1001cc:	f3 0f 1e fb          	endbr32 
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile(
  1001d3:	cd 79                	int    $0x79
  1001d5:	89 ec                	mov    %ebp,%esp
	"int %0 \n"
	"movl %%ebp, %%esp \n"
	:
	: "i"(T_SWITCH_TOK));
}
  1001d7:	90                   	nop
  1001d8:	5d                   	pop    %ebp
  1001d9:	c3                   	ret    

001001da <lab1_switch_test>:

static void
lab1_switch_test(void)
{
  1001da:	f3 0f 1e fb          	endbr32 
  1001de:	55                   	push   %ebp
  1001df:	89 e5                	mov    %esp,%ebp
  1001e1:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001e4:	e8 11 ff ff ff       	call   1000fa <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e9:	83 ec 0c             	sub    $0xc,%esp
  1001ec:	68 48 37 10 00       	push   $0x103748
  1001f1:	e8 7f 00 00 00       	call   100275 <cprintf>
  1001f6:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001f9:	e8 bd ff ff ff       	call   1001bb <lab1_switch_to_user>
    lab1_print_cur_status();
  1001fe:	e8 f7 fe ff ff       	call   1000fa <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100203:	83 ec 0c             	sub    $0xc,%esp
  100206:	68 68 37 10 00       	push   $0x103768
  10020b:	e8 65 00 00 00       	call   100275 <cprintf>
  100210:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  100213:	e8 b4 ff ff ff       	call   1001cc <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100218:	e8 dd fe ff ff       	call   1000fa <lab1_print_cur_status>
}
  10021d:	90                   	nop
  10021e:	c9                   	leave  
  10021f:	c3                   	ret    

00100220 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100220:	f3 0f 1e fb          	endbr32 
  100224:	55                   	push   %ebp
  100225:	89 e5                	mov    %esp,%ebp
  100227:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  10022a:	83 ec 0c             	sub    $0xc,%esp
  10022d:	ff 75 08             	pushl  0x8(%ebp)
  100230:	e8 35 14 00 00       	call   10166a <cons_putc>
  100235:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  100238:	8b 45 0c             	mov    0xc(%ebp),%eax
  10023b:	8b 00                	mov    (%eax),%eax
  10023d:	8d 50 01             	lea    0x1(%eax),%edx
  100240:	8b 45 0c             	mov    0xc(%ebp),%eax
  100243:	89 10                	mov    %edx,(%eax)
}
  100245:	90                   	nop
  100246:	c9                   	leave  
  100247:	c3                   	ret    

00100248 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100248:	f3 0f 1e fb          	endbr32 
  10024c:	55                   	push   %ebp
  10024d:	89 e5                	mov    %esp,%ebp
  10024f:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100259:	ff 75 0c             	pushl  0xc(%ebp)
  10025c:	ff 75 08             	pushl  0x8(%ebp)
  10025f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100262:	50                   	push   %eax
  100263:	68 20 02 10 00       	push   $0x100220
  100268:	e8 f2 2f 00 00       	call   10325f <vprintfmt>
  10026d:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100270:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100273:	c9                   	leave  
  100274:	c3                   	ret    

00100275 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100275:	f3 0f 1e fb          	endbr32 
  100279:	55                   	push   %ebp
  10027a:	89 e5                	mov    %esp,%ebp
  10027c:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10027f:	8d 45 0c             	lea    0xc(%ebp),%eax
  100282:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100285:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100288:	83 ec 08             	sub    $0x8,%esp
  10028b:	50                   	push   %eax
  10028c:	ff 75 08             	pushl  0x8(%ebp)
  10028f:	e8 b4 ff ff ff       	call   100248 <vcprintf>
  100294:	83 c4 10             	add    $0x10,%esp
  100297:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10029a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10029d:	c9                   	leave  
  10029e:	c3                   	ret    

0010029f <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10029f:	f3 0f 1e fb          	endbr32 
  1002a3:	55                   	push   %ebp
  1002a4:	89 e5                	mov    %esp,%ebp
  1002a6:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  1002a9:	83 ec 0c             	sub    $0xc,%esp
  1002ac:	ff 75 08             	pushl  0x8(%ebp)
  1002af:	e8 b6 13 00 00       	call   10166a <cons_putc>
  1002b4:	83 c4 10             	add    $0x10,%esp
}
  1002b7:	90                   	nop
  1002b8:	c9                   	leave  
  1002b9:	c3                   	ret    

001002ba <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002ba:	f3 0f 1e fb          	endbr32 
  1002be:	55                   	push   %ebp
  1002bf:	89 e5                	mov    %esp,%ebp
  1002c1:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  1002c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002cb:	eb 14                	jmp    1002e1 <cputs+0x27>
        cputch(c, &cnt);
  1002cd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002d1:	83 ec 08             	sub    $0x8,%esp
  1002d4:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002d7:	52                   	push   %edx
  1002d8:	50                   	push   %eax
  1002d9:	e8 42 ff ff ff       	call   100220 <cputch>
  1002de:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
  1002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1002e4:	8d 50 01             	lea    0x1(%eax),%edx
  1002e7:	89 55 08             	mov    %edx,0x8(%ebp)
  1002ea:	0f b6 00             	movzbl (%eax),%eax
  1002ed:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002f0:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002f4:	75 d7                	jne    1002cd <cputs+0x13>
    }
    cputch('\n', &cnt);
  1002f6:	83 ec 08             	sub    $0x8,%esp
  1002f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002fc:	50                   	push   %eax
  1002fd:	6a 0a                	push   $0xa
  1002ff:	e8 1c ff ff ff       	call   100220 <cputch>
  100304:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100307:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10030a:	c9                   	leave  
  10030b:	c3                   	ret    

0010030c <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10030c:	f3 0f 1e fb          	endbr32 
  100310:	55                   	push   %ebp
  100311:	89 e5                	mov    %esp,%ebp
  100313:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100316:	90                   	nop
  100317:	e8 82 13 00 00       	call   10169e <cons_getc>
  10031c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10031f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100323:	74 f2                	je     100317 <getchar+0xb>
        /* do nothing */;
    return c;
  100325:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100328:	c9                   	leave  
  100329:	c3                   	ret    

0010032a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10032a:	f3 0f 1e fb          	endbr32 
  10032e:	55                   	push   %ebp
  10032f:	89 e5                	mov    %esp,%ebp
  100331:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  100334:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100338:	74 13                	je     10034d <readline+0x23>
        cprintf("%s", prompt);
  10033a:	83 ec 08             	sub    $0x8,%esp
  10033d:	ff 75 08             	pushl  0x8(%ebp)
  100340:	68 87 37 10 00       	push   $0x103787
  100345:	e8 2b ff ff ff       	call   100275 <cprintf>
  10034a:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  10034d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100354:	e8 b3 ff ff ff       	call   10030c <getchar>
  100359:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10035c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100360:	79 0a                	jns    10036c <readline+0x42>
            return NULL;
  100362:	b8 00 00 00 00       	mov    $0x0,%eax
  100367:	e9 82 00 00 00       	jmp    1003ee <readline+0xc4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10036c:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100370:	7e 2b                	jle    10039d <readline+0x73>
  100372:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100379:	7f 22                	jg     10039d <readline+0x73>
            cputchar(c);
  10037b:	83 ec 0c             	sub    $0xc,%esp
  10037e:	ff 75 f0             	pushl  -0x10(%ebp)
  100381:	e8 19 ff ff ff       	call   10029f <cputchar>
  100386:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10038c:	8d 50 01             	lea    0x1(%eax),%edx
  10038f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100392:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100395:	88 90 40 fa 10 00    	mov    %dl,0x10fa40(%eax)
  10039b:	eb 4c                	jmp    1003e9 <readline+0xbf>
        }
        else if (c == '\b' && i > 0) {
  10039d:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003a1:	75 1a                	jne    1003bd <readline+0x93>
  1003a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003a7:	7e 14                	jle    1003bd <readline+0x93>
            cputchar(c);
  1003a9:	83 ec 0c             	sub    $0xc,%esp
  1003ac:	ff 75 f0             	pushl  -0x10(%ebp)
  1003af:	e8 eb fe ff ff       	call   10029f <cputchar>
  1003b4:	83 c4 10             	add    $0x10,%esp
            i --;
  1003b7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1003bb:	eb 2c                	jmp    1003e9 <readline+0xbf>
        }
        else if (c == '\n' || c == '\r') {
  1003bd:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003c1:	74 06                	je     1003c9 <readline+0x9f>
  1003c3:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003c7:	75 8b                	jne    100354 <readline+0x2a>
            cputchar(c);
  1003c9:	83 ec 0c             	sub    $0xc,%esp
  1003cc:	ff 75 f0             	pushl  -0x10(%ebp)
  1003cf:	e8 cb fe ff ff       	call   10029f <cputchar>
  1003d4:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1003d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003da:	05 40 fa 10 00       	add    $0x10fa40,%eax
  1003df:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003e2:	b8 40 fa 10 00       	mov    $0x10fa40,%eax
  1003e7:	eb 05                	jmp    1003ee <readline+0xc4>
        c = getchar();
  1003e9:	e9 66 ff ff ff       	jmp    100354 <readline+0x2a>
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
  1003f7:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003fa:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  1003ff:	85 c0                	test   %eax,%eax
  100401:	75 5f                	jne    100462 <__panic+0x72>
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
  100413:	83 ec 04             	sub    $0x4,%esp
  100416:	ff 75 0c             	pushl  0xc(%ebp)
  100419:	ff 75 08             	pushl  0x8(%ebp)
  10041c:	68 8a 37 10 00       	push   $0x10378a
  100421:	e8 4f fe ff ff       	call   100275 <cprintf>
  100426:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10042c:	83 ec 08             	sub    $0x8,%esp
  10042f:	50                   	push   %eax
  100430:	ff 75 10             	pushl  0x10(%ebp)
  100433:	e8 10 fe ff ff       	call   100248 <vcprintf>
  100438:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  10043b:	83 ec 0c             	sub    $0xc,%esp
  10043e:	68 a6 37 10 00       	push   $0x1037a6
  100443:	e8 2d fe ff ff       	call   100275 <cprintf>
  100448:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
  10044b:	83 ec 0c             	sub    $0xc,%esp
  10044e:	68 a8 37 10 00       	push   $0x1037a8
  100453:	e8 1d fe ff ff       	call   100275 <cprintf>
  100458:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
  10045b:	e8 25 06 00 00       	call   100a85 <print_stackframe>
  100460:	eb 01                	jmp    100463 <__panic+0x73>
        goto panic_dead;
  100462:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100463:	e8 81 14 00 00       	call   1018e9 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100468:	83 ec 0c             	sub    $0xc,%esp
  10046b:	6a 00                	push   $0x0
  10046d:	e8 4c 08 00 00       	call   100cbe <kmonitor>
  100472:	83 c4 10             	add    $0x10,%esp
  100475:	eb f1                	jmp    100468 <__panic+0x78>

00100477 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100477:	f3 0f 1e fb          	endbr32 
  10047b:	55                   	push   %ebp
  10047c:	89 e5                	mov    %esp,%ebp
  10047e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100481:	8d 45 14             	lea    0x14(%ebp),%eax
  100484:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100487:	83 ec 04             	sub    $0x4,%esp
  10048a:	ff 75 0c             	pushl  0xc(%ebp)
  10048d:	ff 75 08             	pushl  0x8(%ebp)
  100490:	68 ba 37 10 00       	push   $0x1037ba
  100495:	e8 db fd ff ff       	call   100275 <cprintf>
  10049a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  10049d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004a0:	83 ec 08             	sub    $0x8,%esp
  1004a3:	50                   	push   %eax
  1004a4:	ff 75 10             	pushl  0x10(%ebp)
  1004a7:	e8 9c fd ff ff       	call   100248 <vcprintf>
  1004ac:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  1004af:	83 ec 0c             	sub    $0xc,%esp
  1004b2:	68 a6 37 10 00       	push   $0x1037a6
  1004b7:	e8 b9 fd ff ff       	call   100275 <cprintf>
  1004bc:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  1004bf:	90                   	nop
  1004c0:	c9                   	leave  
  1004c1:	c3                   	ret    

001004c2 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004c2:	f3 0f 1e fb          	endbr32 
  1004c6:	55                   	push   %ebp
  1004c7:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004c9:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  1004ce:	5d                   	pop    %ebp
  1004cf:	c3                   	ret    

001004d0 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004d0:	f3 0f 1e fb          	endbr32 
  1004d4:	55                   	push   %ebp
  1004d5:	89 e5                	mov    %esp,%ebp
  1004d7:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004da:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004dd:	8b 00                	mov    (%eax),%eax
  1004df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004e2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004e5:	8b 00                	mov    (%eax),%eax
  1004e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004f1:	e9 d2 00 00 00       	jmp    1005c8 <stab_binsearch+0xf8>
        int true_m = (l + r) / 2, m = true_m;
  1004f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004fc:	01 d0                	add    %edx,%eax
  1004fe:	89 c2                	mov    %eax,%edx
  100500:	c1 ea 1f             	shr    $0x1f,%edx
  100503:	01 d0                	add    %edx,%eax
  100505:	d1 f8                	sar    %eax
  100507:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10050a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10050d:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100510:	eb 04                	jmp    100516 <stab_binsearch+0x46>
            m --;
  100512:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100519:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10051c:	7c 1f                	jl     10053d <stab_binsearch+0x6d>
  10051e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100521:	89 d0                	mov    %edx,%eax
  100523:	01 c0                	add    %eax,%eax
  100525:	01 d0                	add    %edx,%eax
  100527:	c1 e0 02             	shl    $0x2,%eax
  10052a:	89 c2                	mov    %eax,%edx
  10052c:	8b 45 08             	mov    0x8(%ebp),%eax
  10052f:	01 d0                	add    %edx,%eax
  100531:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100535:	0f b6 c0             	movzbl %al,%eax
  100538:	39 45 14             	cmp    %eax,0x14(%ebp)
  10053b:	75 d5                	jne    100512 <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  10053d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100540:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100543:	7d 0b                	jge    100550 <stab_binsearch+0x80>
            l = true_m + 1;
  100545:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100548:	83 c0 01             	add    $0x1,%eax
  10054b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10054e:	eb 78                	jmp    1005c8 <stab_binsearch+0xf8>
        }

        // actual binary search
        any_matches = 1;
  100550:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100557:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10055a:	89 d0                	mov    %edx,%eax
  10055c:	01 c0                	add    %eax,%eax
  10055e:	01 d0                	add    %edx,%eax
  100560:	c1 e0 02             	shl    $0x2,%eax
  100563:	89 c2                	mov    %eax,%edx
  100565:	8b 45 08             	mov    0x8(%ebp),%eax
  100568:	01 d0                	add    %edx,%eax
  10056a:	8b 40 08             	mov    0x8(%eax),%eax
  10056d:	39 45 18             	cmp    %eax,0x18(%ebp)
  100570:	76 13                	jbe    100585 <stab_binsearch+0xb5>
            *region_left = m;
  100572:	8b 45 0c             	mov    0xc(%ebp),%eax
  100575:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100578:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10057a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10057d:	83 c0 01             	add    $0x1,%eax
  100580:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100583:	eb 43                	jmp    1005c8 <stab_binsearch+0xf8>
        } else if (stabs[m].n_value > addr) {
  100585:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100588:	89 d0                	mov    %edx,%eax
  10058a:	01 c0                	add    %eax,%eax
  10058c:	01 d0                	add    %edx,%eax
  10058e:	c1 e0 02             	shl    $0x2,%eax
  100591:	89 c2                	mov    %eax,%edx
  100593:	8b 45 08             	mov    0x8(%ebp),%eax
  100596:	01 d0                	add    %edx,%eax
  100598:	8b 40 08             	mov    0x8(%eax),%eax
  10059b:	39 45 18             	cmp    %eax,0x18(%ebp)
  10059e:	73 16                	jae    1005b6 <stab_binsearch+0xe6>
            *region_right = m - 1;
  1005a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005a3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005a6:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a9:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005ae:	83 e8 01             	sub    $0x1,%eax
  1005b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005b4:	eb 12                	jmp    1005c8 <stab_binsearch+0xf8>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005bc:	89 10                	mov    %edx,(%eax)
            l = m;
  1005be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005c4:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  1005c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005ce:	0f 8e 22 ff ff ff    	jle    1004f6 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  1005d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005d8:	75 0f                	jne    1005e9 <stab_binsearch+0x119>
        *region_right = *region_left - 1;
  1005da:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005dd:	8b 00                	mov    (%eax),%eax
  1005df:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005e2:	8b 45 10             	mov    0x10(%ebp),%eax
  1005e5:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005e7:	eb 3f                	jmp    100628 <stab_binsearch+0x158>
        l = *region_right;
  1005e9:	8b 45 10             	mov    0x10(%ebp),%eax
  1005ec:	8b 00                	mov    (%eax),%eax
  1005ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005f1:	eb 04                	jmp    1005f7 <stab_binsearch+0x127>
  1005f3:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fa:	8b 00                	mov    (%eax),%eax
  1005fc:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005ff:	7e 1f                	jle    100620 <stab_binsearch+0x150>
  100601:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100604:	89 d0                	mov    %edx,%eax
  100606:	01 c0                	add    %eax,%eax
  100608:	01 d0                	add    %edx,%eax
  10060a:	c1 e0 02             	shl    $0x2,%eax
  10060d:	89 c2                	mov    %eax,%edx
  10060f:	8b 45 08             	mov    0x8(%ebp),%eax
  100612:	01 d0                	add    %edx,%eax
  100614:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100618:	0f b6 c0             	movzbl %al,%eax
  10061b:	39 45 14             	cmp    %eax,0x14(%ebp)
  10061e:	75 d3                	jne    1005f3 <stab_binsearch+0x123>
        *region_left = l;
  100620:	8b 45 0c             	mov    0xc(%ebp),%eax
  100623:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100626:	89 10                	mov    %edx,(%eax)
}
  100628:	90                   	nop
  100629:	c9                   	leave  
  10062a:	c3                   	ret    

0010062b <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10062b:	f3 0f 1e fb          	endbr32 
  10062f:	55                   	push   %ebp
  100630:	89 e5                	mov    %esp,%ebp
  100632:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100635:	8b 45 0c             	mov    0xc(%ebp),%eax
  100638:	c7 00 d8 37 10 00    	movl   $0x1037d8,(%eax)
    info->eip_line = 0;
  10063e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100641:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100648:	8b 45 0c             	mov    0xc(%ebp),%eax
  10064b:	c7 40 08 d8 37 10 00 	movl   $0x1037d8,0x8(%eax)
    info->eip_fn_namelen = 9;
  100652:	8b 45 0c             	mov    0xc(%ebp),%eax
  100655:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065f:	8b 55 08             	mov    0x8(%ebp),%edx
  100662:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100665:	8b 45 0c             	mov    0xc(%ebp),%eax
  100668:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10066f:	c7 45 f4 ec 3f 10 00 	movl   $0x103fec,-0xc(%ebp)
    stab_end = __STAB_END__;
  100676:	c7 45 f0 9c ce 10 00 	movl   $0x10ce9c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10067d:	c7 45 ec 9d ce 10 00 	movl   $0x10ce9d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100684:	c7 45 e8 bf ef 10 00 	movl   $0x10efbf,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10068b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10068e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100691:	76 0d                	jbe    1006a0 <debuginfo_eip+0x75>
  100693:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100696:	83 e8 01             	sub    $0x1,%eax
  100699:	0f b6 00             	movzbl (%eax),%eax
  10069c:	84 c0                	test   %al,%al
  10069e:	74 0a                	je     1006aa <debuginfo_eip+0x7f>
        return -1;
  1006a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a5:	e9 85 02 00 00       	jmp    10092f <debuginfo_eip+0x304>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006b4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006b7:	c1 f8 02             	sar    $0x2,%eax
  1006ba:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006c0:	83 e8 01             	sub    $0x1,%eax
  1006c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006c6:	ff 75 08             	pushl  0x8(%ebp)
  1006c9:	6a 64                	push   $0x64
  1006cb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006ce:	50                   	push   %eax
  1006cf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006d2:	50                   	push   %eax
  1006d3:	ff 75 f4             	pushl  -0xc(%ebp)
  1006d6:	e8 f5 fd ff ff       	call   1004d0 <stab_binsearch>
  1006db:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  1006de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006e1:	85 c0                	test   %eax,%eax
  1006e3:	75 0a                	jne    1006ef <debuginfo_eip+0xc4>
        return -1;
  1006e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006ea:	e9 40 02 00 00       	jmp    10092f <debuginfo_eip+0x304>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006fb:	ff 75 08             	pushl  0x8(%ebp)
  1006fe:	6a 24                	push   $0x24
  100700:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100703:	50                   	push   %eax
  100704:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100707:	50                   	push   %eax
  100708:	ff 75 f4             	pushl  -0xc(%ebp)
  10070b:	e8 c0 fd ff ff       	call   1004d0 <stab_binsearch>
  100710:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  100713:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100716:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100719:	39 c2                	cmp    %eax,%edx
  10071b:	7f 78                	jg     100795 <debuginfo_eip+0x16a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10071d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100720:	89 c2                	mov    %eax,%edx
  100722:	89 d0                	mov    %edx,%eax
  100724:	01 c0                	add    %eax,%eax
  100726:	01 d0                	add    %edx,%eax
  100728:	c1 e0 02             	shl    $0x2,%eax
  10072b:	89 c2                	mov    %eax,%edx
  10072d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100730:	01 d0                	add    %edx,%eax
  100732:	8b 10                	mov    (%eax),%edx
  100734:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100737:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10073a:	39 c2                	cmp    %eax,%edx
  10073c:	73 22                	jae    100760 <debuginfo_eip+0x135>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10073e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100741:	89 c2                	mov    %eax,%edx
  100743:	89 d0                	mov    %edx,%eax
  100745:	01 c0                	add    %eax,%eax
  100747:	01 d0                	add    %edx,%eax
  100749:	c1 e0 02             	shl    $0x2,%eax
  10074c:	89 c2                	mov    %eax,%edx
  10074e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100751:	01 d0                	add    %edx,%eax
  100753:	8b 10                	mov    (%eax),%edx
  100755:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100758:	01 c2                	add    %eax,%edx
  10075a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075d:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100760:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100763:	89 c2                	mov    %eax,%edx
  100765:	89 d0                	mov    %edx,%eax
  100767:	01 c0                	add    %eax,%eax
  100769:	01 d0                	add    %edx,%eax
  10076b:	c1 e0 02             	shl    $0x2,%eax
  10076e:	89 c2                	mov    %eax,%edx
  100770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100773:	01 d0                	add    %edx,%eax
  100775:	8b 50 08             	mov    0x8(%eax),%edx
  100778:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077b:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10077e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100781:	8b 40 10             	mov    0x10(%eax),%eax
  100784:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100787:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10078a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10078d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100790:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100793:	eb 15                	jmp    1007aa <debuginfo_eip+0x17f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100795:	8b 45 0c             	mov    0xc(%ebp),%eax
  100798:	8b 55 08             	mov    0x8(%ebp),%edx
  10079b:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10079e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ad:	8b 40 08             	mov    0x8(%eax),%eax
  1007b0:	83 ec 08             	sub    $0x8,%esp
  1007b3:	6a 3a                	push   $0x3a
  1007b5:	50                   	push   %eax
  1007b6:	e8 c1 25 00 00       	call   102d7c <strfind>
  1007bb:	83 c4 10             	add    $0x10,%esp
  1007be:	8b 55 0c             	mov    0xc(%ebp),%edx
  1007c1:	8b 52 08             	mov    0x8(%edx),%edx
  1007c4:	29 d0                	sub    %edx,%eax
  1007c6:	89 c2                	mov    %eax,%edx
  1007c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007cb:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007ce:	83 ec 0c             	sub    $0xc,%esp
  1007d1:	ff 75 08             	pushl  0x8(%ebp)
  1007d4:	6a 44                	push   $0x44
  1007d6:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007d9:	50                   	push   %eax
  1007da:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007dd:	50                   	push   %eax
  1007de:	ff 75 f4             	pushl  -0xc(%ebp)
  1007e1:	e8 ea fc ff ff       	call   1004d0 <stab_binsearch>
  1007e6:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1007e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007ef:	39 c2                	cmp    %eax,%edx
  1007f1:	7f 24                	jg     100817 <debuginfo_eip+0x1ec>
        info->eip_line = stabs[rline].n_desc;
  1007f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007f6:	89 c2                	mov    %eax,%edx
  1007f8:	89 d0                	mov    %edx,%eax
  1007fa:	01 c0                	add    %eax,%eax
  1007fc:	01 d0                	add    %edx,%eax
  1007fe:	c1 e0 02             	shl    $0x2,%eax
  100801:	89 c2                	mov    %eax,%edx
  100803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100806:	01 d0                	add    %edx,%eax
  100808:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10080c:	0f b7 d0             	movzwl %ax,%edx
  10080f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100812:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100815:	eb 13                	jmp    10082a <debuginfo_eip+0x1ff>
        return -1;
  100817:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10081c:	e9 0e 01 00 00       	jmp    10092f <debuginfo_eip+0x304>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100821:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100824:	83 e8 01             	sub    $0x1,%eax
  100827:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10082a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10082d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100830:	39 c2                	cmp    %eax,%edx
  100832:	7c 56                	jl     10088a <debuginfo_eip+0x25f>
           && stabs[lline].n_type != N_SOL
  100834:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100837:	89 c2                	mov    %eax,%edx
  100839:	89 d0                	mov    %edx,%eax
  10083b:	01 c0                	add    %eax,%eax
  10083d:	01 d0                	add    %edx,%eax
  10083f:	c1 e0 02             	shl    $0x2,%eax
  100842:	89 c2                	mov    %eax,%edx
  100844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100847:	01 d0                	add    %edx,%eax
  100849:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10084d:	3c 84                	cmp    $0x84,%al
  10084f:	74 39                	je     10088a <debuginfo_eip+0x25f>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100851:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100854:	89 c2                	mov    %eax,%edx
  100856:	89 d0                	mov    %edx,%eax
  100858:	01 c0                	add    %eax,%eax
  10085a:	01 d0                	add    %edx,%eax
  10085c:	c1 e0 02             	shl    $0x2,%eax
  10085f:	89 c2                	mov    %eax,%edx
  100861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100864:	01 d0                	add    %edx,%eax
  100866:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10086a:	3c 64                	cmp    $0x64,%al
  10086c:	75 b3                	jne    100821 <debuginfo_eip+0x1f6>
  10086e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100871:	89 c2                	mov    %eax,%edx
  100873:	89 d0                	mov    %edx,%eax
  100875:	01 c0                	add    %eax,%eax
  100877:	01 d0                	add    %edx,%eax
  100879:	c1 e0 02             	shl    $0x2,%eax
  10087c:	89 c2                	mov    %eax,%edx
  10087e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100881:	01 d0                	add    %edx,%eax
  100883:	8b 40 08             	mov    0x8(%eax),%eax
  100886:	85 c0                	test   %eax,%eax
  100888:	74 97                	je     100821 <debuginfo_eip+0x1f6>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10088a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10088d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100890:	39 c2                	cmp    %eax,%edx
  100892:	7c 42                	jl     1008d6 <debuginfo_eip+0x2ab>
  100894:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100897:	89 c2                	mov    %eax,%edx
  100899:	89 d0                	mov    %edx,%eax
  10089b:	01 c0                	add    %eax,%eax
  10089d:	01 d0                	add    %edx,%eax
  10089f:	c1 e0 02             	shl    $0x2,%eax
  1008a2:	89 c2                	mov    %eax,%edx
  1008a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008a7:	01 d0                	add    %edx,%eax
  1008a9:	8b 10                	mov    (%eax),%edx
  1008ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008ae:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1008b1:	39 c2                	cmp    %eax,%edx
  1008b3:	73 21                	jae    1008d6 <debuginfo_eip+0x2ab>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008b8:	89 c2                	mov    %eax,%edx
  1008ba:	89 d0                	mov    %edx,%eax
  1008bc:	01 c0                	add    %eax,%eax
  1008be:	01 d0                	add    %edx,%eax
  1008c0:	c1 e0 02             	shl    $0x2,%eax
  1008c3:	89 c2                	mov    %eax,%edx
  1008c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008c8:	01 d0                	add    %edx,%eax
  1008ca:	8b 10                	mov    (%eax),%edx
  1008cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008cf:	01 c2                	add    %eax,%edx
  1008d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d4:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008d6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008dc:	39 c2                	cmp    %eax,%edx
  1008de:	7d 4a                	jge    10092a <debuginfo_eip+0x2ff>
        for (lline = lfun + 1;
  1008e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008e3:	83 c0 01             	add    $0x1,%eax
  1008e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008e9:	eb 18                	jmp    100903 <debuginfo_eip+0x2d8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ee:	8b 40 14             	mov    0x14(%eax),%eax
  1008f1:	8d 50 01             	lea    0x1(%eax),%edx
  1008f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008f7:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008fd:	83 c0 01             	add    $0x1,%eax
  100900:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100903:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100906:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100909:	39 c2                	cmp    %eax,%edx
  10090b:	7d 1d                	jge    10092a <debuginfo_eip+0x2ff>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10090d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100910:	89 c2                	mov    %eax,%edx
  100912:	89 d0                	mov    %edx,%eax
  100914:	01 c0                	add    %eax,%eax
  100916:	01 d0                	add    %edx,%eax
  100918:	c1 e0 02             	shl    $0x2,%eax
  10091b:	89 c2                	mov    %eax,%edx
  10091d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100920:	01 d0                	add    %edx,%eax
  100922:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100926:	3c a0                	cmp    $0xa0,%al
  100928:	74 c1                	je     1008eb <debuginfo_eip+0x2c0>
        }
    }
    return 0;
  10092a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10092f:	c9                   	leave  
  100930:	c3                   	ret    

00100931 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100931:	f3 0f 1e fb          	endbr32 
  100935:	55                   	push   %ebp
  100936:	89 e5                	mov    %esp,%ebp
  100938:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10093b:	83 ec 0c             	sub    $0xc,%esp
  10093e:	68 e2 37 10 00       	push   $0x1037e2
  100943:	e8 2d f9 ff ff       	call   100275 <cprintf>
  100948:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10094b:	83 ec 08             	sub    $0x8,%esp
  10094e:	68 00 00 10 00       	push   $0x100000
  100953:	68 fb 37 10 00       	push   $0x1037fb
  100958:	e8 18 f9 ff ff       	call   100275 <cprintf>
  10095d:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100960:	83 ec 08             	sub    $0x8,%esp
  100963:	68 d1 36 10 00       	push   $0x1036d1
  100968:	68 13 38 10 00       	push   $0x103813
  10096d:	e8 03 f9 ff ff       	call   100275 <cprintf>
  100972:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100975:	83 ec 08             	sub    $0x8,%esp
  100978:	68 16 fa 10 00       	push   $0x10fa16
  10097d:	68 2b 38 10 00       	push   $0x10382b
  100982:	e8 ee f8 ff ff       	call   100275 <cprintf>
  100987:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10098a:	83 ec 08             	sub    $0x8,%esp
  10098d:	68 80 0d 11 00       	push   $0x110d80
  100992:	68 43 38 10 00       	push   $0x103843
  100997:	e8 d9 f8 ff ff       	call   100275 <cprintf>
  10099c:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10099f:	b8 80 0d 11 00       	mov    $0x110d80,%eax
  1009a4:	2d 00 00 10 00       	sub    $0x100000,%eax
  1009a9:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009ae:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009b4:	85 c0                	test   %eax,%eax
  1009b6:	0f 48 c2             	cmovs  %edx,%eax
  1009b9:	c1 f8 0a             	sar    $0xa,%eax
  1009bc:	83 ec 08             	sub    $0x8,%esp
  1009bf:	50                   	push   %eax
  1009c0:	68 5c 38 10 00       	push   $0x10385c
  1009c5:	e8 ab f8 ff ff       	call   100275 <cprintf>
  1009ca:	83 c4 10             	add    $0x10,%esp
}
  1009cd:	90                   	nop
  1009ce:	c9                   	leave  
  1009cf:	c3                   	ret    

001009d0 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009d0:	f3 0f 1e fb          	endbr32 
  1009d4:	55                   	push   %ebp
  1009d5:	89 e5                	mov    %esp,%ebp
  1009d7:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009dd:	83 ec 08             	sub    $0x8,%esp
  1009e0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009e3:	50                   	push   %eax
  1009e4:	ff 75 08             	pushl  0x8(%ebp)
  1009e7:	e8 3f fc ff ff       	call   10062b <debuginfo_eip>
  1009ec:	83 c4 10             	add    $0x10,%esp
  1009ef:	85 c0                	test   %eax,%eax
  1009f1:	74 15                	je     100a08 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009f3:	83 ec 08             	sub    $0x8,%esp
  1009f6:	ff 75 08             	pushl  0x8(%ebp)
  1009f9:	68 86 38 10 00       	push   $0x103886
  1009fe:	e8 72 f8 ff ff       	call   100275 <cprintf>
  100a03:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a06:	eb 65                	jmp    100a6d <print_debuginfo+0x9d>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a0f:	eb 1c                	jmp    100a2d <print_debuginfo+0x5d>
            fnname[j] = info.eip_fn_name[j];
  100a11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a17:	01 d0                	add    %edx,%eax
  100a19:	0f b6 00             	movzbl (%eax),%eax
  100a1c:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a25:	01 ca                	add    %ecx,%edx
  100a27:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a29:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100a2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a30:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a33:	7c dc                	jl     100a11 <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a35:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a3e:	01 d0                	add    %edx,%eax
  100a40:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a43:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a46:	8b 55 08             	mov    0x8(%ebp),%edx
  100a49:	89 d1                	mov    %edx,%ecx
  100a4b:	29 c1                	sub    %eax,%ecx
  100a4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a50:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a53:	83 ec 0c             	sub    $0xc,%esp
  100a56:	51                   	push   %ecx
  100a57:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a5d:	51                   	push   %ecx
  100a5e:	52                   	push   %edx
  100a5f:	50                   	push   %eax
  100a60:	68 a2 38 10 00       	push   $0x1038a2
  100a65:	e8 0b f8 ff ff       	call   100275 <cprintf>
  100a6a:	83 c4 20             	add    $0x20,%esp
}
  100a6d:	90                   	nop
  100a6e:	c9                   	leave  
  100a6f:	c3                   	ret    

00100a70 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a70:	f3 0f 1e fb          	endbr32 
  100a74:	55                   	push   %ebp
  100a75:	89 e5                	mov    %esp,%ebp
  100a77:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a7a:	8b 45 04             	mov    0x4(%ebp),%eax
  100a7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a80:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a83:	c9                   	leave  
  100a84:	c3                   	ret    

00100a85 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a85:	f3 0f 1e fb          	endbr32 
  100a89:	55                   	push   %ebp
  100a8a:	89 e5                	mov    %esp,%ebp
  100a8c:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a8f:	89 e8                	mov    %ebp,%eax
  100a91:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a94:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  100a97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a9a:	e8 d1 ff ff ff       	call   100a70 <read_eip>
  100a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100aa2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100aa9:	e9 8d 00 00 00       	jmp    100b3b <print_stackframe+0xb6>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100aae:	83 ec 04             	sub    $0x4,%esp
  100ab1:	ff 75 f0             	pushl  -0x10(%ebp)
  100ab4:	ff 75 f4             	pushl  -0xc(%ebp)
  100ab7:	68 b4 38 10 00       	push   $0x1038b4
  100abc:	e8 b4 f7 ff ff       	call   100275 <cprintf>
  100ac1:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
  100ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac7:	83 c0 08             	add    $0x8,%eax
  100aca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100acd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100ad4:	eb 26                	jmp    100afc <print_stackframe+0x77>
            cprintf("0x%08x ", args[j]);
  100ad6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100ad9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ae0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100ae3:	01 d0                	add    %edx,%eax
  100ae5:	8b 00                	mov    (%eax),%eax
  100ae7:	83 ec 08             	sub    $0x8,%esp
  100aea:	50                   	push   %eax
  100aeb:	68 d0 38 10 00       	push   $0x1038d0
  100af0:	e8 80 f7 ff ff       	call   100275 <cprintf>
  100af5:	83 c4 10             	add    $0x10,%esp
        for (j = 0; j < 4; j ++) {
  100af8:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100afc:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b00:	7e d4                	jle    100ad6 <print_stackframe+0x51>
        }
        cprintf("\n");
  100b02:	83 ec 0c             	sub    $0xc,%esp
  100b05:	68 d8 38 10 00       	push   $0x1038d8
  100b0a:	e8 66 f7 ff ff       	call   100275 <cprintf>
  100b0f:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
  100b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b15:	83 e8 01             	sub    $0x1,%eax
  100b18:	83 ec 0c             	sub    $0xc,%esp
  100b1b:	50                   	push   %eax
  100b1c:	e8 af fe ff ff       	call   1009d0 <print_debuginfo>
  100b21:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
  100b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b27:	83 c0 04             	add    $0x4,%eax
  100b2a:	8b 00                	mov    (%eax),%eax
  100b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b32:	8b 00                	mov    (%eax),%eax
  100b34:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100b37:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100b3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b3f:	74 0a                	je     100b4b <print_stackframe+0xc6>
  100b41:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b45:	0f 8e 63 ff ff ff    	jle    100aae <print_stackframe+0x29>
    }
}
  100b4b:	90                   	nop
  100b4c:	c9                   	leave  
  100b4d:	c3                   	ret    

00100b4e <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b4e:	f3 0f 1e fb          	endbr32 
  100b52:	55                   	push   %ebp
  100b53:	89 e5                	mov    %esp,%ebp
  100b55:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100b58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b5f:	eb 0c                	jmp    100b6d <parse+0x1f>
            *buf ++ = '\0';
  100b61:	8b 45 08             	mov    0x8(%ebp),%eax
  100b64:	8d 50 01             	lea    0x1(%eax),%edx
  100b67:	89 55 08             	mov    %edx,0x8(%ebp)
  100b6a:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b70:	0f b6 00             	movzbl (%eax),%eax
  100b73:	84 c0                	test   %al,%al
  100b75:	74 1e                	je     100b95 <parse+0x47>
  100b77:	8b 45 08             	mov    0x8(%ebp),%eax
  100b7a:	0f b6 00             	movzbl (%eax),%eax
  100b7d:	0f be c0             	movsbl %al,%eax
  100b80:	83 ec 08             	sub    $0x8,%esp
  100b83:	50                   	push   %eax
  100b84:	68 5c 39 10 00       	push   $0x10395c
  100b89:	e8 b7 21 00 00       	call   102d45 <strchr>
  100b8e:	83 c4 10             	add    $0x10,%esp
  100b91:	85 c0                	test   %eax,%eax
  100b93:	75 cc                	jne    100b61 <parse+0x13>
        }
        if (*buf == '\0') {
  100b95:	8b 45 08             	mov    0x8(%ebp),%eax
  100b98:	0f b6 00             	movzbl (%eax),%eax
  100b9b:	84 c0                	test   %al,%al
  100b9d:	74 65                	je     100c04 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b9f:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ba3:	75 12                	jne    100bb7 <parse+0x69>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ba5:	83 ec 08             	sub    $0x8,%esp
  100ba8:	6a 10                	push   $0x10
  100baa:	68 61 39 10 00       	push   $0x103961
  100baf:	e8 c1 f6 ff ff       	call   100275 <cprintf>
  100bb4:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bba:	8d 50 01             	lea    0x1(%eax),%edx
  100bbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bc0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bca:	01 c2                	add    %eax,%edx
  100bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  100bcf:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bd1:	eb 04                	jmp    100bd7 <parse+0x89>
            buf ++;
  100bd3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  100bda:	0f b6 00             	movzbl (%eax),%eax
  100bdd:	84 c0                	test   %al,%al
  100bdf:	74 8c                	je     100b6d <parse+0x1f>
  100be1:	8b 45 08             	mov    0x8(%ebp),%eax
  100be4:	0f b6 00             	movzbl (%eax),%eax
  100be7:	0f be c0             	movsbl %al,%eax
  100bea:	83 ec 08             	sub    $0x8,%esp
  100bed:	50                   	push   %eax
  100bee:	68 5c 39 10 00       	push   $0x10395c
  100bf3:	e8 4d 21 00 00       	call   102d45 <strchr>
  100bf8:	83 c4 10             	add    $0x10,%esp
  100bfb:	85 c0                	test   %eax,%eax
  100bfd:	74 d4                	je     100bd3 <parse+0x85>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bff:	e9 69 ff ff ff       	jmp    100b6d <parse+0x1f>
            break;
  100c04:	90                   	nop
        }
    }
    return argc;
  100c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c08:	c9                   	leave  
  100c09:	c3                   	ret    

00100c0a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c0a:	f3 0f 1e fb          	endbr32 
  100c0e:	55                   	push   %ebp
  100c0f:	89 e5                	mov    %esp,%ebp
  100c11:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c14:	83 ec 08             	sub    $0x8,%esp
  100c17:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c1a:	50                   	push   %eax
  100c1b:	ff 75 08             	pushl  0x8(%ebp)
  100c1e:	e8 2b ff ff ff       	call   100b4e <parse>
  100c23:	83 c4 10             	add    $0x10,%esp
  100c26:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c2d:	75 0a                	jne    100c39 <runcmd+0x2f>
        return 0;
  100c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  100c34:	e9 83 00 00 00       	jmp    100cbc <runcmd+0xb2>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c40:	eb 59                	jmp    100c9b <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c42:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c48:	89 d0                	mov    %edx,%eax
  100c4a:	01 c0                	add    %eax,%eax
  100c4c:	01 d0                	add    %edx,%eax
  100c4e:	c1 e0 02             	shl    $0x2,%eax
  100c51:	05 00 f0 10 00       	add    $0x10f000,%eax
  100c56:	8b 00                	mov    (%eax),%eax
  100c58:	83 ec 08             	sub    $0x8,%esp
  100c5b:	51                   	push   %ecx
  100c5c:	50                   	push   %eax
  100c5d:	e8 3c 20 00 00       	call   102c9e <strcmp>
  100c62:	83 c4 10             	add    $0x10,%esp
  100c65:	85 c0                	test   %eax,%eax
  100c67:	75 2e                	jne    100c97 <runcmd+0x8d>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c6c:	89 d0                	mov    %edx,%eax
  100c6e:	01 c0                	add    %eax,%eax
  100c70:	01 d0                	add    %edx,%eax
  100c72:	c1 e0 02             	shl    $0x2,%eax
  100c75:	05 08 f0 10 00       	add    $0x10f008,%eax
  100c7a:	8b 10                	mov    (%eax),%edx
  100c7c:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c7f:	83 c0 04             	add    $0x4,%eax
  100c82:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c85:	83 e9 01             	sub    $0x1,%ecx
  100c88:	83 ec 04             	sub    $0x4,%esp
  100c8b:	ff 75 0c             	pushl  0xc(%ebp)
  100c8e:	50                   	push   %eax
  100c8f:	51                   	push   %ecx
  100c90:	ff d2                	call   *%edx
  100c92:	83 c4 10             	add    $0x10,%esp
  100c95:	eb 25                	jmp    100cbc <runcmd+0xb2>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c97:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c9e:	83 f8 02             	cmp    $0x2,%eax
  100ca1:	76 9f                	jbe    100c42 <runcmd+0x38>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ca3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100ca6:	83 ec 08             	sub    $0x8,%esp
  100ca9:	50                   	push   %eax
  100caa:	68 7f 39 10 00       	push   $0x10397f
  100caf:	e8 c1 f5 ff ff       	call   100275 <cprintf>
  100cb4:	83 c4 10             	add    $0x10,%esp
    return 0;
  100cb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbc:	c9                   	leave  
  100cbd:	c3                   	ret    

00100cbe <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100cbe:	f3 0f 1e fb          	endbr32 
  100cc2:	55                   	push   %ebp
  100cc3:	89 e5                	mov    %esp,%ebp
  100cc5:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100cc8:	83 ec 0c             	sub    $0xc,%esp
  100ccb:	68 98 39 10 00       	push   $0x103998
  100cd0:	e8 a0 f5 ff ff       	call   100275 <cprintf>
  100cd5:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100cd8:	83 ec 0c             	sub    $0xc,%esp
  100cdb:	68 c0 39 10 00       	push   $0x1039c0
  100ce0:	e8 90 f5 ff ff       	call   100275 <cprintf>
  100ce5:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100ce8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cec:	74 0e                	je     100cfc <kmonitor+0x3e>
        print_trapframe(tf);
  100cee:	83 ec 0c             	sub    $0xc,%esp
  100cf1:	ff 75 08             	pushl  0x8(%ebp)
  100cf4:	e8 e1 0d 00 00       	call   101ada <print_trapframe>
  100cf9:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cfc:	83 ec 0c             	sub    $0xc,%esp
  100cff:	68 e5 39 10 00       	push   $0x1039e5
  100d04:	e8 21 f6 ff ff       	call   10032a <readline>
  100d09:	83 c4 10             	add    $0x10,%esp
  100d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d13:	74 e7                	je     100cfc <kmonitor+0x3e>
            if (runcmd(buf, tf) < 0) {
  100d15:	83 ec 08             	sub    $0x8,%esp
  100d18:	ff 75 08             	pushl  0x8(%ebp)
  100d1b:	ff 75 f4             	pushl  -0xc(%ebp)
  100d1e:	e8 e7 fe ff ff       	call   100c0a <runcmd>
  100d23:	83 c4 10             	add    $0x10,%esp
  100d26:	85 c0                	test   %eax,%eax
  100d28:	78 02                	js     100d2c <kmonitor+0x6e>
        if ((buf = readline("K> ")) != NULL) {
  100d2a:	eb d0                	jmp    100cfc <kmonitor+0x3e>
                break;
  100d2c:	90                   	nop
            }
        }
    }
}
  100d2d:	90                   	nop
  100d2e:	c9                   	leave  
  100d2f:	c3                   	ret    

00100d30 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d30:	f3 0f 1e fb          	endbr32 
  100d34:	55                   	push   %ebp
  100d35:	89 e5                	mov    %esp,%ebp
  100d37:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d41:	eb 3c                	jmp    100d7f <mon_help+0x4f>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d46:	89 d0                	mov    %edx,%eax
  100d48:	01 c0                	add    %eax,%eax
  100d4a:	01 d0                	add    %edx,%eax
  100d4c:	c1 e0 02             	shl    $0x2,%eax
  100d4f:	05 04 f0 10 00       	add    $0x10f004,%eax
  100d54:	8b 08                	mov    (%eax),%ecx
  100d56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d59:	89 d0                	mov    %edx,%eax
  100d5b:	01 c0                	add    %eax,%eax
  100d5d:	01 d0                	add    %edx,%eax
  100d5f:	c1 e0 02             	shl    $0x2,%eax
  100d62:	05 00 f0 10 00       	add    $0x10f000,%eax
  100d67:	8b 00                	mov    (%eax),%eax
  100d69:	83 ec 04             	sub    $0x4,%esp
  100d6c:	51                   	push   %ecx
  100d6d:	50                   	push   %eax
  100d6e:	68 e9 39 10 00       	push   $0x1039e9
  100d73:	e8 fd f4 ff ff       	call   100275 <cprintf>
  100d78:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100d7b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d82:	83 f8 02             	cmp    $0x2,%eax
  100d85:	76 bc                	jbe    100d43 <mon_help+0x13>
    }
    return 0;
  100d87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d8c:	c9                   	leave  
  100d8d:	c3                   	ret    

00100d8e <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d8e:	f3 0f 1e fb          	endbr32 
  100d92:	55                   	push   %ebp
  100d93:	89 e5                	mov    %esp,%ebp
  100d95:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d98:	e8 94 fb ff ff       	call   100931 <print_kerninfo>
    return 0;
  100d9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100da2:	c9                   	leave  
  100da3:	c3                   	ret    

00100da4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100da4:	f3 0f 1e fb          	endbr32 
  100da8:	55                   	push   %ebp
  100da9:	89 e5                	mov    %esp,%ebp
  100dab:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100dae:	e8 d2 fc ff ff       	call   100a85 <print_stackframe>
    return 0;
  100db3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100db8:	c9                   	leave  
  100db9:	c3                   	ret    

00100dba <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dba:	f3 0f 1e fb          	endbr32 
  100dbe:	55                   	push   %ebp
  100dbf:	89 e5                	mov    %esp,%ebp
  100dc1:	83 ec 18             	sub    $0x18,%esp
  100dc4:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100dca:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dce:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dd2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dd6:	ee                   	out    %al,(%dx)
}
  100dd7:	90                   	nop
  100dd8:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dde:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100de2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100de6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dea:	ee                   	out    %al,(%dx)
}
  100deb:	90                   	nop
  100dec:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100df2:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100df6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dfa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dfe:	ee                   	out    %al,(%dx)
}
  100dff:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e00:	c7 05 08 09 11 00 00 	movl   $0x0,0x110908
  100e07:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e0a:	83 ec 0c             	sub    $0xc,%esp
  100e0d:	68 f2 39 10 00       	push   $0x1039f2
  100e12:	e8 5e f4 ff ff       	call   100275 <cprintf>
  100e17:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100e1a:	83 ec 0c             	sub    $0xc,%esp
  100e1d:	6a 00                	push   $0x0
  100e1f:	e8 39 09 00 00       	call   10175d <pic_enable>
  100e24:	83 c4 10             	add    $0x10,%esp
}
  100e27:	90                   	nop
  100e28:	c9                   	leave  
  100e29:	c3                   	ret    

00100e2a <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e2a:	f3 0f 1e fb          	endbr32 
  100e2e:	55                   	push   %ebp
  100e2f:	89 e5                	mov    %esp,%ebp
  100e31:	83 ec 10             	sub    $0x10,%esp
  100e34:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e3a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e3e:	89 c2                	mov    %eax,%edx
  100e40:	ec                   	in     (%dx),%al
  100e41:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e44:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e4a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e4e:	89 c2                	mov    %eax,%edx
  100e50:	ec                   	in     (%dx),%al
  100e51:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e54:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e5a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e5e:	89 c2                	mov    %eax,%edx
  100e60:	ec                   	in     (%dx),%al
  100e61:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e64:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e6a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e6e:	89 c2                	mov    %eax,%edx
  100e70:	ec                   	in     (%dx),%al
  100e71:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e74:	90                   	nop
  100e75:	c9                   	leave  
  100e76:	c3                   	ret    

00100e77 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e77:	f3 0f 1e fb          	endbr32 
  100e7b:	55                   	push   %ebp
  100e7c:	89 e5                	mov    %esp,%ebp
  100e7e:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100e81:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8b:	0f b7 00             	movzwl (%eax),%eax
  100e8e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e95:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e9d:	0f b7 00             	movzwl (%eax),%eax
  100ea0:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100ea4:	74 12                	je     100eb8 <cga_init+0x41>
        cp = (uint16_t*)MONO_BUF;
  100ea6:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ead:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100eb4:	b4 03 
  100eb6:	eb 13                	jmp    100ecb <cga_init+0x54>
    } else {
        *cp = was;
  100eb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ebb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ebf:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ec2:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100ec9:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ecb:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ed2:	0f b7 c0             	movzwl %ax,%eax
  100ed5:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ed9:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100edd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ee1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ee5:	ee                   	out    %al,(%dx)
}
  100ee6:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100ee7:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100eee:	83 c0 01             	add    $0x1,%eax
  100ef1:	0f b7 c0             	movzwl %ax,%eax
  100ef4:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ef8:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100efc:	89 c2                	mov    %eax,%edx
  100efe:	ec                   	in     (%dx),%al
  100eff:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f02:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f06:	0f b6 c0             	movzbl %al,%eax
  100f09:	c1 e0 08             	shl    $0x8,%eax
  100f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f0f:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100f16:	0f b7 c0             	movzwl %ax,%eax
  100f19:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f1d:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f21:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f25:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f29:	ee                   	out    %al,(%dx)
}
  100f2a:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f2b:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100f32:	83 c0 01             	add    $0x1,%eax
  100f35:	0f b7 c0             	movzwl %ax,%eax
  100f38:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f3c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f40:	89 c2                	mov    %eax,%edx
  100f42:	ec                   	in     (%dx),%al
  100f43:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f46:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f4a:	0f b6 c0             	movzbl %al,%eax
  100f4d:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f53:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;
  100f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f5b:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100f61:	90                   	nop
  100f62:	c9                   	leave  
  100f63:	c3                   	ret    

00100f64 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f64:	f3 0f 1e fb          	endbr32 
  100f68:	55                   	push   %ebp
  100f69:	89 e5                	mov    %esp,%ebp
  100f6b:	83 ec 38             	sub    $0x38,%esp
  100f6e:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f74:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f78:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f7c:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f80:	ee                   	out    %al,(%dx)
}
  100f81:	90                   	nop
  100f82:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f88:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f8c:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f90:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f94:	ee                   	out    %al,(%dx)
}
  100f95:	90                   	nop
  100f96:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f9c:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fa0:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fa4:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fa8:	ee                   	out    %al,(%dx)
}
  100fa9:	90                   	nop
  100faa:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fb0:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fb4:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fb8:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fbc:	ee                   	out    %al,(%dx)
}
  100fbd:	90                   	nop
  100fbe:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fc4:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fc8:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fcc:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fd0:	ee                   	out    %al,(%dx)
}
  100fd1:	90                   	nop
  100fd2:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fd8:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fdc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fe0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fe4:	ee                   	out    %al,(%dx)
}
  100fe5:	90                   	nop
  100fe6:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fec:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ff0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ff4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ff8:	ee                   	out    %al,(%dx)
}
  100ff9:	90                   	nop
  100ffa:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101000:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  101004:	89 c2                	mov    %eax,%edx
  101006:	ec                   	in     (%dx),%al
  101007:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  10100a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10100e:	3c ff                	cmp    $0xff,%al
  101010:	0f 95 c0             	setne  %al
  101013:	0f b6 c0             	movzbl %al,%eax
  101016:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  10101b:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101021:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101025:	89 c2                	mov    %eax,%edx
  101027:	ec                   	in     (%dx),%al
  101028:	88 45 f1             	mov    %al,-0xf(%ebp)
  10102b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101031:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101035:	89 c2                	mov    %eax,%edx
  101037:	ec                   	in     (%dx),%al
  101038:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10103b:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101040:	85 c0                	test   %eax,%eax
  101042:	74 0d                	je     101051 <serial_init+0xed>
        pic_enable(IRQ_COM1);
  101044:	83 ec 0c             	sub    $0xc,%esp
  101047:	6a 04                	push   $0x4
  101049:	e8 0f 07 00 00       	call   10175d <pic_enable>
  10104e:	83 c4 10             	add    $0x10,%esp
    }
}
  101051:	90                   	nop
  101052:	c9                   	leave  
  101053:	c3                   	ret    

00101054 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101054:	f3 0f 1e fb          	endbr32 
  101058:	55                   	push   %ebp
  101059:	89 e5                	mov    %esp,%ebp
  10105b:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10105e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101065:	eb 09                	jmp    101070 <lpt_putc_sub+0x1c>
        delay();
  101067:	e8 be fd ff ff       	call   100e2a <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10106c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101070:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101076:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10107a:	89 c2                	mov    %eax,%edx
  10107c:	ec                   	in     (%dx),%al
  10107d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101080:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101084:	84 c0                	test   %al,%al
  101086:	78 09                	js     101091 <lpt_putc_sub+0x3d>
  101088:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10108f:	7e d6                	jle    101067 <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  101091:	8b 45 08             	mov    0x8(%ebp),%eax
  101094:	0f b6 c0             	movzbl %al,%eax
  101097:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  10109d:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010a0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010a4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010a8:	ee                   	out    %al,(%dx)
}
  1010a9:	90                   	nop
  1010aa:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010b0:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010b4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010b8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010bc:	ee                   	out    %al,(%dx)
}
  1010bd:	90                   	nop
  1010be:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010c4:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010c8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010cc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010d0:	ee                   	out    %al,(%dx)
}
  1010d1:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010d2:	90                   	nop
  1010d3:	c9                   	leave  
  1010d4:	c3                   	ret    

001010d5 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010d5:	f3 0f 1e fb          	endbr32 
  1010d9:	55                   	push   %ebp
  1010da:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1010dc:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010e0:	74 0d                	je     1010ef <lpt_putc+0x1a>
        lpt_putc_sub(c);
  1010e2:	ff 75 08             	pushl  0x8(%ebp)
  1010e5:	e8 6a ff ff ff       	call   101054 <lpt_putc_sub>
  1010ea:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010ed:	eb 1e                	jmp    10110d <lpt_putc+0x38>
        lpt_putc_sub('\b');
  1010ef:	6a 08                	push   $0x8
  1010f1:	e8 5e ff ff ff       	call   101054 <lpt_putc_sub>
  1010f6:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  1010f9:	6a 20                	push   $0x20
  1010fb:	e8 54 ff ff ff       	call   101054 <lpt_putc_sub>
  101100:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  101103:	6a 08                	push   $0x8
  101105:	e8 4a ff ff ff       	call   101054 <lpt_putc_sub>
  10110a:	83 c4 04             	add    $0x4,%esp
}
  10110d:	90                   	nop
  10110e:	c9                   	leave  
  10110f:	c3                   	ret    

00101110 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101110:	f3 0f 1e fb          	endbr32 
  101114:	55                   	push   %ebp
  101115:	89 e5                	mov    %esp,%ebp
  101117:	53                   	push   %ebx
  101118:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10111b:	8b 45 08             	mov    0x8(%ebp),%eax
  10111e:	b0 00                	mov    $0x0,%al
  101120:	85 c0                	test   %eax,%eax
  101122:	75 07                	jne    10112b <cga_putc+0x1b>
        c |= 0x0700;
  101124:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10112b:	8b 45 08             	mov    0x8(%ebp),%eax
  10112e:	0f b6 c0             	movzbl %al,%eax
  101131:	83 f8 0d             	cmp    $0xd,%eax
  101134:	74 6c                	je     1011a2 <cga_putc+0x92>
  101136:	83 f8 0d             	cmp    $0xd,%eax
  101139:	0f 8f 9d 00 00 00    	jg     1011dc <cga_putc+0xcc>
  10113f:	83 f8 08             	cmp    $0x8,%eax
  101142:	74 0a                	je     10114e <cga_putc+0x3e>
  101144:	83 f8 0a             	cmp    $0xa,%eax
  101147:	74 49                	je     101192 <cga_putc+0x82>
  101149:	e9 8e 00 00 00       	jmp    1011dc <cga_putc+0xcc>
    case '\b':
        if (crt_pos > 0) {
  10114e:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101155:	66 85 c0             	test   %ax,%ax
  101158:	0f 84 a4 00 00 00    	je     101202 <cga_putc+0xf2>
            crt_pos --;
  10115e:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101165:	83 e8 01             	sub    $0x1,%eax
  101168:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10116e:	8b 45 08             	mov    0x8(%ebp),%eax
  101171:	b0 00                	mov    $0x0,%al
  101173:	83 c8 20             	or     $0x20,%eax
  101176:	89 c1                	mov    %eax,%ecx
  101178:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  10117d:	0f b7 15 64 fe 10 00 	movzwl 0x10fe64,%edx
  101184:	0f b7 d2             	movzwl %dx,%edx
  101187:	01 d2                	add    %edx,%edx
  101189:	01 d0                	add    %edx,%eax
  10118b:	89 ca                	mov    %ecx,%edx
  10118d:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  101190:	eb 70                	jmp    101202 <cga_putc+0xf2>
    case '\n':
        crt_pos += CRT_COLS;
  101192:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101199:	83 c0 50             	add    $0x50,%eax
  10119c:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011a2:	0f b7 1d 64 fe 10 00 	movzwl 0x10fe64,%ebx
  1011a9:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  1011b0:	0f b7 c1             	movzwl %cx,%eax
  1011b3:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1011b9:	c1 e8 10             	shr    $0x10,%eax
  1011bc:	89 c2                	mov    %eax,%edx
  1011be:	66 c1 ea 06          	shr    $0x6,%dx
  1011c2:	89 d0                	mov    %edx,%eax
  1011c4:	c1 e0 02             	shl    $0x2,%eax
  1011c7:	01 d0                	add    %edx,%eax
  1011c9:	c1 e0 04             	shl    $0x4,%eax
  1011cc:	29 c1                	sub    %eax,%ecx
  1011ce:	89 ca                	mov    %ecx,%edx
  1011d0:	89 d8                	mov    %ebx,%eax
  1011d2:	29 d0                	sub    %edx,%eax
  1011d4:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  1011da:	eb 27                	jmp    101203 <cga_putc+0xf3>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011dc:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  1011e2:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011e9:	8d 50 01             	lea    0x1(%eax),%edx
  1011ec:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  1011f3:	0f b7 c0             	movzwl %ax,%eax
  1011f6:	01 c0                	add    %eax,%eax
  1011f8:	01 c8                	add    %ecx,%eax
  1011fa:	8b 55 08             	mov    0x8(%ebp),%edx
  1011fd:	66 89 10             	mov    %dx,(%eax)
        break;
  101200:	eb 01                	jmp    101203 <cga_putc+0xf3>
        break;
  101202:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101203:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10120a:	66 3d cf 07          	cmp    $0x7cf,%ax
  10120e:	76 59                	jbe    101269 <cga_putc+0x159>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101210:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  101215:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10121b:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  101220:	83 ec 04             	sub    $0x4,%esp
  101223:	68 00 0f 00 00       	push   $0xf00
  101228:	52                   	push   %edx
  101229:	50                   	push   %eax
  10122a:	e8 24 1d 00 00       	call   102f53 <memmove>
  10122f:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101232:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101239:	eb 15                	jmp    101250 <cga_putc+0x140>
            crt_buf[i] = 0x0700 | ' ';
  10123b:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  101240:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101243:	01 d2                	add    %edx,%edx
  101245:	01 d0                	add    %edx,%eax
  101247:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10124c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101250:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101257:	7e e2                	jle    10123b <cga_putc+0x12b>
        }
        crt_pos -= CRT_COLS;
  101259:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101260:	83 e8 50             	sub    $0x50,%eax
  101263:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101269:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  101270:	0f b7 c0             	movzwl %ax,%eax
  101273:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101277:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10127b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10127f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101283:	ee                   	out    %al,(%dx)
}
  101284:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  101285:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10128c:	66 c1 e8 08          	shr    $0x8,%ax
  101290:	0f b6 c0             	movzbl %al,%eax
  101293:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  10129a:	83 c2 01             	add    $0x1,%edx
  10129d:	0f b7 d2             	movzwl %dx,%edx
  1012a0:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012a4:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012a7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012ab:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012af:	ee                   	out    %al,(%dx)
}
  1012b0:	90                   	nop
    outb(addr_6845, 15);
  1012b1:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  1012b8:	0f b7 c0             	movzwl %ax,%eax
  1012bb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012bf:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012c3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012c7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012cb:	ee                   	out    %al,(%dx)
}
  1012cc:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  1012cd:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1012d4:	0f b6 c0             	movzbl %al,%eax
  1012d7:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  1012de:	83 c2 01             	add    $0x1,%edx
  1012e1:	0f b7 d2             	movzwl %dx,%edx
  1012e4:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012e8:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012eb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012ef:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012f3:	ee                   	out    %al,(%dx)
}
  1012f4:	90                   	nop
}
  1012f5:	90                   	nop
  1012f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1012f9:	c9                   	leave  
  1012fa:	c3                   	ret    

001012fb <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012fb:	f3 0f 1e fb          	endbr32 
  1012ff:	55                   	push   %ebp
  101300:	89 e5                	mov    %esp,%ebp
  101302:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101305:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10130c:	eb 09                	jmp    101317 <serial_putc_sub+0x1c>
        delay();
  10130e:	e8 17 fb ff ff       	call   100e2a <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101313:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101317:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10131d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101321:	89 c2                	mov    %eax,%edx
  101323:	ec                   	in     (%dx),%al
  101324:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101327:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10132b:	0f b6 c0             	movzbl %al,%eax
  10132e:	83 e0 20             	and    $0x20,%eax
  101331:	85 c0                	test   %eax,%eax
  101333:	75 09                	jne    10133e <serial_putc_sub+0x43>
  101335:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10133c:	7e d0                	jle    10130e <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  10133e:	8b 45 08             	mov    0x8(%ebp),%eax
  101341:	0f b6 c0             	movzbl %al,%eax
  101344:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10134a:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10134d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101351:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101355:	ee                   	out    %al,(%dx)
}
  101356:	90                   	nop
}
  101357:	90                   	nop
  101358:	c9                   	leave  
  101359:	c3                   	ret    

0010135a <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10135a:	f3 0f 1e fb          	endbr32 
  10135e:	55                   	push   %ebp
  10135f:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101361:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101365:	74 0d                	je     101374 <serial_putc+0x1a>
        serial_putc_sub(c);
  101367:	ff 75 08             	pushl  0x8(%ebp)
  10136a:	e8 8c ff ff ff       	call   1012fb <serial_putc_sub>
  10136f:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101372:	eb 1e                	jmp    101392 <serial_putc+0x38>
        serial_putc_sub('\b');
  101374:	6a 08                	push   $0x8
  101376:	e8 80 ff ff ff       	call   1012fb <serial_putc_sub>
  10137b:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  10137e:	6a 20                	push   $0x20
  101380:	e8 76 ff ff ff       	call   1012fb <serial_putc_sub>
  101385:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  101388:	6a 08                	push   $0x8
  10138a:	e8 6c ff ff ff       	call   1012fb <serial_putc_sub>
  10138f:	83 c4 04             	add    $0x4,%esp
}
  101392:	90                   	nop
  101393:	c9                   	leave  
  101394:	c3                   	ret    

00101395 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101395:	f3 0f 1e fb          	endbr32 
  101399:	55                   	push   %ebp
  10139a:	89 e5                	mov    %esp,%ebp
  10139c:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10139f:	eb 33                	jmp    1013d4 <cons_intr+0x3f>
        if (c != 0) {
  1013a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013a5:	74 2d                	je     1013d4 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  1013a7:	a1 84 00 11 00       	mov    0x110084,%eax
  1013ac:	8d 50 01             	lea    0x1(%eax),%edx
  1013af:	89 15 84 00 11 00    	mov    %edx,0x110084
  1013b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013b8:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013be:	a1 84 00 11 00       	mov    0x110084,%eax
  1013c3:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013c8:	75 0a                	jne    1013d4 <cons_intr+0x3f>
                cons.wpos = 0;
  1013ca:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  1013d1:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1013d7:	ff d0                	call   *%eax
  1013d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013dc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013e0:	75 bf                	jne    1013a1 <cons_intr+0xc>
            }
        }
    }
}
  1013e2:	90                   	nop
  1013e3:	90                   	nop
  1013e4:	c9                   	leave  
  1013e5:	c3                   	ret    

001013e6 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013e6:	f3 0f 1e fb          	endbr32 
  1013ea:	55                   	push   %ebp
  1013eb:	89 e5                	mov    %esp,%ebp
  1013ed:	83 ec 10             	sub    $0x10,%esp
  1013f0:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013f6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013fa:	89 c2                	mov    %eax,%edx
  1013fc:	ec                   	in     (%dx),%al
  1013fd:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101400:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101404:	0f b6 c0             	movzbl %al,%eax
  101407:	83 e0 01             	and    $0x1,%eax
  10140a:	85 c0                	test   %eax,%eax
  10140c:	75 07                	jne    101415 <serial_proc_data+0x2f>
        return -1;
  10140e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101413:	eb 2a                	jmp    10143f <serial_proc_data+0x59>
  101415:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10141b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10141f:	89 c2                	mov    %eax,%edx
  101421:	ec                   	in     (%dx),%al
  101422:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101425:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101429:	0f b6 c0             	movzbl %al,%eax
  10142c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10142f:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101433:	75 07                	jne    10143c <serial_proc_data+0x56>
        c = '\b';
  101435:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10143c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10143f:	c9                   	leave  
  101440:	c3                   	ret    

00101441 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101441:	f3 0f 1e fb          	endbr32 
  101445:	55                   	push   %ebp
  101446:	89 e5                	mov    %esp,%ebp
  101448:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  10144b:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101450:	85 c0                	test   %eax,%eax
  101452:	74 10                	je     101464 <serial_intr+0x23>
        cons_intr(serial_proc_data);
  101454:	83 ec 0c             	sub    $0xc,%esp
  101457:	68 e6 13 10 00       	push   $0x1013e6
  10145c:	e8 34 ff ff ff       	call   101395 <cons_intr>
  101461:	83 c4 10             	add    $0x10,%esp
    }
}
  101464:	90                   	nop
  101465:	c9                   	leave  
  101466:	c3                   	ret    

00101467 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101467:	f3 0f 1e fb          	endbr32 
  10146b:	55                   	push   %ebp
  10146c:	89 e5                	mov    %esp,%ebp
  10146e:	83 ec 28             	sub    $0x28,%esp
  101471:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101477:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10147b:	89 c2                	mov    %eax,%edx
  10147d:	ec                   	in     (%dx),%al
  10147e:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101481:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101485:	0f b6 c0             	movzbl %al,%eax
  101488:	83 e0 01             	and    $0x1,%eax
  10148b:	85 c0                	test   %eax,%eax
  10148d:	75 0a                	jne    101499 <kbd_proc_data+0x32>
        return -1;
  10148f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101494:	e9 5e 01 00 00       	jmp    1015f7 <kbd_proc_data+0x190>
  101499:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10149f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1014a3:	89 c2                	mov    %eax,%edx
  1014a5:	ec                   	in     (%dx),%al
  1014a6:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014a9:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014ad:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014b0:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014b4:	75 17                	jne    1014cd <kbd_proc_data+0x66>
        // E0 escape character
        shift |= E0ESC;
  1014b6:	a1 88 00 11 00       	mov    0x110088,%eax
  1014bb:	83 c8 40             	or     $0x40,%eax
  1014be:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  1014c3:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c8:	e9 2a 01 00 00       	jmp    1015f7 <kbd_proc_data+0x190>
    } else if (data & 0x80) {
  1014cd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d1:	84 c0                	test   %al,%al
  1014d3:	79 47                	jns    10151c <kbd_proc_data+0xb5>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014d5:	a1 88 00 11 00       	mov    0x110088,%eax
  1014da:	83 e0 40             	and    $0x40,%eax
  1014dd:	85 c0                	test   %eax,%eax
  1014df:	75 09                	jne    1014ea <kbd_proc_data+0x83>
  1014e1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e5:	83 e0 7f             	and    $0x7f,%eax
  1014e8:	eb 04                	jmp    1014ee <kbd_proc_data+0x87>
  1014ea:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ee:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014f1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f5:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  1014fc:	83 c8 40             	or     $0x40,%eax
  1014ff:	0f b6 c0             	movzbl %al,%eax
  101502:	f7 d0                	not    %eax
  101504:	89 c2                	mov    %eax,%edx
  101506:	a1 88 00 11 00       	mov    0x110088,%eax
  10150b:	21 d0                	and    %edx,%eax
  10150d:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  101512:	b8 00 00 00 00       	mov    $0x0,%eax
  101517:	e9 db 00 00 00       	jmp    1015f7 <kbd_proc_data+0x190>
    } else if (shift & E0ESC) {
  10151c:	a1 88 00 11 00       	mov    0x110088,%eax
  101521:	83 e0 40             	and    $0x40,%eax
  101524:	85 c0                	test   %eax,%eax
  101526:	74 11                	je     101539 <kbd_proc_data+0xd2>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101528:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10152c:	a1 88 00 11 00       	mov    0x110088,%eax
  101531:	83 e0 bf             	and    $0xffffffbf,%eax
  101534:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  101539:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10153d:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  101544:	0f b6 d0             	movzbl %al,%edx
  101547:	a1 88 00 11 00       	mov    0x110088,%eax
  10154c:	09 d0                	or     %edx,%eax
  10154e:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  101553:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101557:	0f b6 80 40 f1 10 00 	movzbl 0x10f140(%eax),%eax
  10155e:	0f b6 d0             	movzbl %al,%edx
  101561:	a1 88 00 11 00       	mov    0x110088,%eax
  101566:	31 d0                	xor    %edx,%eax
  101568:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  10156d:	a1 88 00 11 00       	mov    0x110088,%eax
  101572:	83 e0 03             	and    $0x3,%eax
  101575:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  10157c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101580:	01 d0                	add    %edx,%eax
  101582:	0f b6 00             	movzbl (%eax),%eax
  101585:	0f b6 c0             	movzbl %al,%eax
  101588:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10158b:	a1 88 00 11 00       	mov    0x110088,%eax
  101590:	83 e0 08             	and    $0x8,%eax
  101593:	85 c0                	test   %eax,%eax
  101595:	74 22                	je     1015b9 <kbd_proc_data+0x152>
        if ('a' <= c && c <= 'z')
  101597:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10159b:	7e 0c                	jle    1015a9 <kbd_proc_data+0x142>
  10159d:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015a1:	7f 06                	jg     1015a9 <kbd_proc_data+0x142>
            c += 'A' - 'a';
  1015a3:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015a7:	eb 10                	jmp    1015b9 <kbd_proc_data+0x152>
        else if ('A' <= c && c <= 'Z')
  1015a9:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015ad:	7e 0a                	jle    1015b9 <kbd_proc_data+0x152>
  1015af:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015b3:	7f 04                	jg     1015b9 <kbd_proc_data+0x152>
            c += 'a' - 'A';
  1015b5:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015b9:	a1 88 00 11 00       	mov    0x110088,%eax
  1015be:	f7 d0                	not    %eax
  1015c0:	83 e0 06             	and    $0x6,%eax
  1015c3:	85 c0                	test   %eax,%eax
  1015c5:	75 2d                	jne    1015f4 <kbd_proc_data+0x18d>
  1015c7:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015ce:	75 24                	jne    1015f4 <kbd_proc_data+0x18d>
        cprintf("Rebooting!\n");
  1015d0:	83 ec 0c             	sub    $0xc,%esp
  1015d3:	68 0d 3a 10 00       	push   $0x103a0d
  1015d8:	e8 98 ec ff ff       	call   100275 <cprintf>
  1015dd:	83 c4 10             	add    $0x10,%esp
  1015e0:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015e6:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1015ea:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015ee:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015f2:	ee                   	out    %al,(%dx)
}
  1015f3:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015f7:	c9                   	leave  
  1015f8:	c3                   	ret    

001015f9 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015f9:	f3 0f 1e fb          	endbr32 
  1015fd:	55                   	push   %ebp
  1015fe:	89 e5                	mov    %esp,%ebp
  101600:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  101603:	83 ec 0c             	sub    $0xc,%esp
  101606:	68 67 14 10 00       	push   $0x101467
  10160b:	e8 85 fd ff ff       	call   101395 <cons_intr>
  101610:	83 c4 10             	add    $0x10,%esp
}
  101613:	90                   	nop
  101614:	c9                   	leave  
  101615:	c3                   	ret    

00101616 <kbd_init>:

static void
kbd_init(void) {
  101616:	f3 0f 1e fb          	endbr32 
  10161a:	55                   	push   %ebp
  10161b:	89 e5                	mov    %esp,%ebp
  10161d:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101620:	e8 d4 ff ff ff       	call   1015f9 <kbd_intr>
    pic_enable(IRQ_KBD);
  101625:	83 ec 0c             	sub    $0xc,%esp
  101628:	6a 01                	push   $0x1
  10162a:	e8 2e 01 00 00       	call   10175d <pic_enable>
  10162f:	83 c4 10             	add    $0x10,%esp
}
  101632:	90                   	nop
  101633:	c9                   	leave  
  101634:	c3                   	ret    

00101635 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101635:	f3 0f 1e fb          	endbr32 
  101639:	55                   	push   %ebp
  10163a:	89 e5                	mov    %esp,%ebp
  10163c:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  10163f:	e8 33 f8 ff ff       	call   100e77 <cga_init>
    serial_init();
  101644:	e8 1b f9 ff ff       	call   100f64 <serial_init>
    kbd_init();
  101649:	e8 c8 ff ff ff       	call   101616 <kbd_init>
    if (!serial_exists) {
  10164e:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101653:	85 c0                	test   %eax,%eax
  101655:	75 10                	jne    101667 <cons_init+0x32>
        cprintf("serial port does not exist!!\n");
  101657:	83 ec 0c             	sub    $0xc,%esp
  10165a:	68 19 3a 10 00       	push   $0x103a19
  10165f:	e8 11 ec ff ff       	call   100275 <cprintf>
  101664:	83 c4 10             	add    $0x10,%esp
    }
}
  101667:	90                   	nop
  101668:	c9                   	leave  
  101669:	c3                   	ret    

0010166a <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10166a:	f3 0f 1e fb          	endbr32 
  10166e:	55                   	push   %ebp
  10166f:	89 e5                	mov    %esp,%ebp
  101671:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  101674:	ff 75 08             	pushl  0x8(%ebp)
  101677:	e8 59 fa ff ff       	call   1010d5 <lpt_putc>
  10167c:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  10167f:	83 ec 0c             	sub    $0xc,%esp
  101682:	ff 75 08             	pushl  0x8(%ebp)
  101685:	e8 86 fa ff ff       	call   101110 <cga_putc>
  10168a:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  10168d:	83 ec 0c             	sub    $0xc,%esp
  101690:	ff 75 08             	pushl  0x8(%ebp)
  101693:	e8 c2 fc ff ff       	call   10135a <serial_putc>
  101698:	83 c4 10             	add    $0x10,%esp
}
  10169b:	90                   	nop
  10169c:	c9                   	leave  
  10169d:	c3                   	ret    

0010169e <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10169e:	f3 0f 1e fb          	endbr32 
  1016a2:	55                   	push   %ebp
  1016a3:	89 e5                	mov    %esp,%ebp
  1016a5:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1016a8:	e8 94 fd ff ff       	call   101441 <serial_intr>
    kbd_intr();
  1016ad:	e8 47 ff ff ff       	call   1015f9 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1016b2:	8b 15 80 00 11 00    	mov    0x110080,%edx
  1016b8:	a1 84 00 11 00       	mov    0x110084,%eax
  1016bd:	39 c2                	cmp    %eax,%edx
  1016bf:	74 36                	je     1016f7 <cons_getc+0x59>
        c = cons.buf[cons.rpos ++];
  1016c1:	a1 80 00 11 00       	mov    0x110080,%eax
  1016c6:	8d 50 01             	lea    0x1(%eax),%edx
  1016c9:	89 15 80 00 11 00    	mov    %edx,0x110080
  1016cf:	0f b6 80 80 fe 10 00 	movzbl 0x10fe80(%eax),%eax
  1016d6:	0f b6 c0             	movzbl %al,%eax
  1016d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1016dc:	a1 80 00 11 00       	mov    0x110080,%eax
  1016e1:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016e6:	75 0a                	jne    1016f2 <cons_getc+0x54>
            cons.rpos = 0;
  1016e8:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  1016ef:	00 00 00 
        }
        return c;
  1016f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016f5:	eb 05                	jmp    1016fc <cons_getc+0x5e>
    }
    return 0;
  1016f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1016fc:	c9                   	leave  
  1016fd:	c3                   	ret    

001016fe <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016fe:	f3 0f 1e fb          	endbr32 
  101702:	55                   	push   %ebp
  101703:	89 e5                	mov    %esp,%ebp
  101705:	83 ec 14             	sub    $0x14,%esp
  101708:	8b 45 08             	mov    0x8(%ebp),%eax
  10170b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10170f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101713:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  101719:	a1 8c 00 11 00       	mov    0x11008c,%eax
  10171e:	85 c0                	test   %eax,%eax
  101720:	74 38                	je     10175a <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  101722:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101726:	0f b6 c0             	movzbl %al,%eax
  101729:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  10172f:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101732:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101736:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10173a:	ee                   	out    %al,(%dx)
}
  10173b:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  10173c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101740:	66 c1 e8 08          	shr    $0x8,%ax
  101744:	0f b6 c0             	movzbl %al,%eax
  101747:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  10174d:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101750:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101754:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101758:	ee                   	out    %al,(%dx)
}
  101759:	90                   	nop
    }
}
  10175a:	90                   	nop
  10175b:	c9                   	leave  
  10175c:	c3                   	ret    

0010175d <pic_enable>:

void
pic_enable(unsigned int irq) {
  10175d:	f3 0f 1e fb          	endbr32 
  101761:	55                   	push   %ebp
  101762:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101764:	8b 45 08             	mov    0x8(%ebp),%eax
  101767:	ba 01 00 00 00       	mov    $0x1,%edx
  10176c:	89 c1                	mov    %eax,%ecx
  10176e:	d3 e2                	shl    %cl,%edx
  101770:	89 d0                	mov    %edx,%eax
  101772:	f7 d0                	not    %eax
  101774:	89 c2                	mov    %eax,%edx
  101776:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  10177d:	21 d0                	and    %edx,%eax
  10177f:	0f b7 c0             	movzwl %ax,%eax
  101782:	50                   	push   %eax
  101783:	e8 76 ff ff ff       	call   1016fe <pic_setmask>
  101788:	83 c4 04             	add    $0x4,%esp
}
  10178b:	90                   	nop
  10178c:	c9                   	leave  
  10178d:	c3                   	ret    

0010178e <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10178e:	f3 0f 1e fb          	endbr32 
  101792:	55                   	push   %ebp
  101793:	89 e5                	mov    %esp,%ebp
  101795:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
  101798:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  10179f:	00 00 00 
  1017a2:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017a8:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017ac:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017b0:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017b4:	ee                   	out    %al,(%dx)
}
  1017b5:	90                   	nop
  1017b6:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1017bc:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017c0:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017c4:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017c8:	ee                   	out    %al,(%dx)
}
  1017c9:	90                   	nop
  1017ca:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017d0:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017d4:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017d8:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017dc:	ee                   	out    %al,(%dx)
}
  1017dd:	90                   	nop
  1017de:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1017e4:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017e8:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017ec:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017f0:	ee                   	out    %al,(%dx)
}
  1017f1:	90                   	nop
  1017f2:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1017f8:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017fc:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101800:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101804:	ee                   	out    %al,(%dx)
}
  101805:	90                   	nop
  101806:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  10180c:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101810:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101814:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101818:	ee                   	out    %al,(%dx)
}
  101819:	90                   	nop
  10181a:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101820:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101824:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101828:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10182c:	ee                   	out    %al,(%dx)
}
  10182d:	90                   	nop
  10182e:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101834:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101838:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10183c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101840:	ee                   	out    %al,(%dx)
}
  101841:	90                   	nop
  101842:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101848:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10184c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101850:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101854:	ee                   	out    %al,(%dx)
}
  101855:	90                   	nop
  101856:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10185c:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101860:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101864:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101868:	ee                   	out    %al,(%dx)
}
  101869:	90                   	nop
  10186a:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101870:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101874:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101878:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10187c:	ee                   	out    %al,(%dx)
}
  10187d:	90                   	nop
  10187e:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101884:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101888:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10188c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101890:	ee                   	out    %al,(%dx)
}
  101891:	90                   	nop
  101892:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101898:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10189c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018a0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018a4:	ee                   	out    %al,(%dx)
}
  1018a5:	90                   	nop
  1018a6:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018ac:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018b0:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018b4:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1018b8:	ee                   	out    %al,(%dx)
}
  1018b9:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018ba:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  1018c1:	66 83 f8 ff          	cmp    $0xffff,%ax
  1018c5:	74 13                	je     1018da <pic_init+0x14c>
        pic_setmask(irq_mask);
  1018c7:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  1018ce:	0f b7 c0             	movzwl %ax,%eax
  1018d1:	50                   	push   %eax
  1018d2:	e8 27 fe ff ff       	call   1016fe <pic_setmask>
  1018d7:	83 c4 04             	add    $0x4,%esp
    }
}
  1018da:	90                   	nop
  1018db:	c9                   	leave  
  1018dc:	c3                   	ret    

001018dd <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1018dd:	f3 0f 1e fb          	endbr32 
  1018e1:	55                   	push   %ebp
  1018e2:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1018e4:	fb                   	sti    
}
  1018e5:	90                   	nop
    sti();
}
  1018e6:	90                   	nop
  1018e7:	5d                   	pop    %ebp
  1018e8:	c3                   	ret    

001018e9 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1018e9:	f3 0f 1e fb          	endbr32 
  1018ed:	55                   	push   %ebp
  1018ee:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  1018f0:	fa                   	cli    
}
  1018f1:	90                   	nop
    cli();
}
  1018f2:	90                   	nop
  1018f3:	5d                   	pop    %ebp
  1018f4:	c3                   	ret    

001018f5 <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  1018f5:	f3 0f 1e fb          	endbr32 
  1018f9:	55                   	push   %ebp
  1018fa:	89 e5                	mov    %esp,%ebp
  1018fc:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1018ff:	83 ec 08             	sub    $0x8,%esp
  101902:	6a 64                	push   $0x64
  101904:	68 40 3a 10 00       	push   $0x103a40
  101909:	e8 67 e9 ff ff       	call   100275 <cprintf>
  10190e:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101911:	90                   	nop
  101912:	c9                   	leave  
  101913:	c3                   	ret    

00101914 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101914:	f3 0f 1e fb          	endbr32 
  101918:	55                   	push   %ebp
  101919:	89 e5                	mov    %esp,%ebp
  10191b:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10191e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101925:	e9 c3 00 00 00       	jmp    1019ed <idt_init+0xd9>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10192a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192d:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  101934:	89 c2                	mov    %eax,%edx
  101936:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101939:	66 89 14 c5 a0 00 11 	mov    %dx,0x1100a0(,%eax,8)
  101940:	00 
  101941:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101944:	66 c7 04 c5 a2 00 11 	movw   $0x8,0x1100a2(,%eax,8)
  10194b:	00 08 00 
  10194e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101951:	0f b6 14 c5 a4 00 11 	movzbl 0x1100a4(,%eax,8),%edx
  101958:	00 
  101959:	83 e2 e0             	and    $0xffffffe0,%edx
  10195c:	88 14 c5 a4 00 11 00 	mov    %dl,0x1100a4(,%eax,8)
  101963:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101966:	0f b6 14 c5 a4 00 11 	movzbl 0x1100a4(,%eax,8),%edx
  10196d:	00 
  10196e:	83 e2 1f             	and    $0x1f,%edx
  101971:	88 14 c5 a4 00 11 00 	mov    %dl,0x1100a4(,%eax,8)
  101978:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197b:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  101982:	00 
  101983:	83 e2 f0             	and    $0xfffffff0,%edx
  101986:	83 ca 0e             	or     $0xe,%edx
  101989:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  101990:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101993:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  10199a:	00 
  10199b:	83 e2 ef             	and    $0xffffffef,%edx
  10199e:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  1019a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a8:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  1019af:	00 
  1019b0:	83 e2 9f             	and    $0xffffff9f,%edx
  1019b3:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  1019ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019bd:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  1019c4:	00 
  1019c5:	83 ca 80             	or     $0xffffff80,%edx
  1019c8:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  1019cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d2:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  1019d9:	c1 e8 10             	shr    $0x10,%eax
  1019dc:	89 c2                	mov    %eax,%edx
  1019de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e1:	66 89 14 c5 a6 00 11 	mov    %dx,0x1100a6(,%eax,8)
  1019e8:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1019e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1019ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f0:	3d ff 00 00 00       	cmp    $0xff,%eax
  1019f5:	0f 86 2f ff ff ff    	jbe    10192a <idt_init+0x16>
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1019fb:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  101a00:	66 a3 68 04 11 00    	mov    %ax,0x110468
  101a06:	66 c7 05 6a 04 11 00 	movw   $0x8,0x11046a
  101a0d:	08 00 
  101a0f:	0f b6 05 6c 04 11 00 	movzbl 0x11046c,%eax
  101a16:	83 e0 e0             	and    $0xffffffe0,%eax
  101a19:	a2 6c 04 11 00       	mov    %al,0x11046c
  101a1e:	0f b6 05 6c 04 11 00 	movzbl 0x11046c,%eax
  101a25:	83 e0 1f             	and    $0x1f,%eax
  101a28:	a2 6c 04 11 00       	mov    %al,0x11046c
  101a2d:	0f b6 05 6d 04 11 00 	movzbl 0x11046d,%eax
  101a34:	83 e0 f0             	and    $0xfffffff0,%eax
  101a37:	83 c8 0e             	or     $0xe,%eax
  101a3a:	a2 6d 04 11 00       	mov    %al,0x11046d
  101a3f:	0f b6 05 6d 04 11 00 	movzbl 0x11046d,%eax
  101a46:	83 e0 ef             	and    $0xffffffef,%eax
  101a49:	a2 6d 04 11 00       	mov    %al,0x11046d
  101a4e:	0f b6 05 6d 04 11 00 	movzbl 0x11046d,%eax
  101a55:	83 c8 60             	or     $0x60,%eax
  101a58:	a2 6d 04 11 00       	mov    %al,0x11046d
  101a5d:	0f b6 05 6d 04 11 00 	movzbl 0x11046d,%eax
  101a64:	83 c8 80             	or     $0xffffff80,%eax
  101a67:	a2 6d 04 11 00       	mov    %al,0x11046d
  101a6c:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  101a71:	c1 e8 10             	shr    $0x10,%eax
  101a74:	66 a3 6e 04 11 00    	mov    %ax,0x11046e
  101a7a:	c7 45 f8 60 f5 10 00 	movl   $0x10f560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101a81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a84:	0f 01 18             	lidtl  (%eax)
}
  101a87:	90                   	nop
	// load the IDT
    lidt(&idt_pd);
}
  101a88:	90                   	nop
  101a89:	c9                   	leave  
  101a8a:	c3                   	ret    

00101a8b <trapname>:

static const char *
trapname(int trapno) {
  101a8b:	f3 0f 1e fb          	endbr32 
  101a8f:	55                   	push   %ebp
  101a90:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a92:	8b 45 08             	mov    0x8(%ebp),%eax
  101a95:	83 f8 13             	cmp    $0x13,%eax
  101a98:	77 0c                	ja     101aa6 <trapname+0x1b>
        return excnames[trapno];
  101a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9d:	8b 04 85 a0 3d 10 00 	mov    0x103da0(,%eax,4),%eax
  101aa4:	eb 18                	jmp    101abe <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101aa6:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101aaa:	7e 0d                	jle    101ab9 <trapname+0x2e>
  101aac:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101ab0:	7f 07                	jg     101ab9 <trapname+0x2e>
        return "Hardware Interrupt";
  101ab2:	b8 4a 3a 10 00       	mov    $0x103a4a,%eax
  101ab7:	eb 05                	jmp    101abe <trapname+0x33>
    }
    return "(unknown trap)";
  101ab9:	b8 5d 3a 10 00       	mov    $0x103a5d,%eax
}
  101abe:	5d                   	pop    %ebp
  101abf:	c3                   	ret    

00101ac0 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101ac0:	f3 0f 1e fb          	endbr32 
  101ac4:	55                   	push   %ebp
  101ac5:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aca:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ace:	66 83 f8 08          	cmp    $0x8,%ax
  101ad2:	0f 94 c0             	sete   %al
  101ad5:	0f b6 c0             	movzbl %al,%eax
}
  101ad8:	5d                   	pop    %ebp
  101ad9:	c3                   	ret    

00101ada <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101ada:	f3 0f 1e fb          	endbr32 
  101ade:	55                   	push   %ebp
  101adf:	89 e5                	mov    %esp,%ebp
  101ae1:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101ae4:	83 ec 08             	sub    $0x8,%esp
  101ae7:	ff 75 08             	pushl  0x8(%ebp)
  101aea:	68 9e 3a 10 00       	push   $0x103a9e
  101aef:	e8 81 e7 ff ff       	call   100275 <cprintf>
  101af4:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101af7:	8b 45 08             	mov    0x8(%ebp),%eax
  101afa:	83 ec 0c             	sub    $0xc,%esp
  101afd:	50                   	push   %eax
  101afe:	e8 b4 01 00 00       	call   101cb7 <print_regs>
  101b03:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b06:	8b 45 08             	mov    0x8(%ebp),%eax
  101b09:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b0d:	0f b7 c0             	movzwl %ax,%eax
  101b10:	83 ec 08             	sub    $0x8,%esp
  101b13:	50                   	push   %eax
  101b14:	68 af 3a 10 00       	push   $0x103aaf
  101b19:	e8 57 e7 ff ff       	call   100275 <cprintf>
  101b1e:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b21:	8b 45 08             	mov    0x8(%ebp),%eax
  101b24:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b28:	0f b7 c0             	movzwl %ax,%eax
  101b2b:	83 ec 08             	sub    $0x8,%esp
  101b2e:	50                   	push   %eax
  101b2f:	68 c2 3a 10 00       	push   $0x103ac2
  101b34:	e8 3c e7 ff ff       	call   100275 <cprintf>
  101b39:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b43:	0f b7 c0             	movzwl %ax,%eax
  101b46:	83 ec 08             	sub    $0x8,%esp
  101b49:	50                   	push   %eax
  101b4a:	68 d5 3a 10 00       	push   $0x103ad5
  101b4f:	e8 21 e7 ff ff       	call   100275 <cprintf>
  101b54:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b57:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b5e:	0f b7 c0             	movzwl %ax,%eax
  101b61:	83 ec 08             	sub    $0x8,%esp
  101b64:	50                   	push   %eax
  101b65:	68 e8 3a 10 00       	push   $0x103ae8
  101b6a:	e8 06 e7 ff ff       	call   100275 <cprintf>
  101b6f:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b72:	8b 45 08             	mov    0x8(%ebp),%eax
  101b75:	8b 40 30             	mov    0x30(%eax),%eax
  101b78:	83 ec 0c             	sub    $0xc,%esp
  101b7b:	50                   	push   %eax
  101b7c:	e8 0a ff ff ff       	call   101a8b <trapname>
  101b81:	83 c4 10             	add    $0x10,%esp
  101b84:	8b 55 08             	mov    0x8(%ebp),%edx
  101b87:	8b 52 30             	mov    0x30(%edx),%edx
  101b8a:	83 ec 04             	sub    $0x4,%esp
  101b8d:	50                   	push   %eax
  101b8e:	52                   	push   %edx
  101b8f:	68 fb 3a 10 00       	push   $0x103afb
  101b94:	e8 dc e6 ff ff       	call   100275 <cprintf>
  101b99:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9f:	8b 40 34             	mov    0x34(%eax),%eax
  101ba2:	83 ec 08             	sub    $0x8,%esp
  101ba5:	50                   	push   %eax
  101ba6:	68 0d 3b 10 00       	push   $0x103b0d
  101bab:	e8 c5 e6 ff ff       	call   100275 <cprintf>
  101bb0:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb6:	8b 40 38             	mov    0x38(%eax),%eax
  101bb9:	83 ec 08             	sub    $0x8,%esp
  101bbc:	50                   	push   %eax
  101bbd:	68 1c 3b 10 00       	push   $0x103b1c
  101bc2:	e8 ae e6 ff ff       	call   100275 <cprintf>
  101bc7:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bca:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bd1:	0f b7 c0             	movzwl %ax,%eax
  101bd4:	83 ec 08             	sub    $0x8,%esp
  101bd7:	50                   	push   %eax
  101bd8:	68 2b 3b 10 00       	push   $0x103b2b
  101bdd:	e8 93 e6 ff ff       	call   100275 <cprintf>
  101be2:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101be5:	8b 45 08             	mov    0x8(%ebp),%eax
  101be8:	8b 40 40             	mov    0x40(%eax),%eax
  101beb:	83 ec 08             	sub    $0x8,%esp
  101bee:	50                   	push   %eax
  101bef:	68 3e 3b 10 00       	push   $0x103b3e
  101bf4:	e8 7c e6 ff ff       	call   100275 <cprintf>
  101bf9:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bfc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c03:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c0a:	eb 3f                	jmp    101c4b <print_trapframe+0x171>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0f:	8b 50 40             	mov    0x40(%eax),%edx
  101c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c15:	21 d0                	and    %edx,%eax
  101c17:	85 c0                	test   %eax,%eax
  101c19:	74 29                	je     101c44 <print_trapframe+0x16a>
  101c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c1e:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101c25:	85 c0                	test   %eax,%eax
  101c27:	74 1b                	je     101c44 <print_trapframe+0x16a>
            cprintf("%s,", IA32flags[i]);
  101c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c2c:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101c33:	83 ec 08             	sub    $0x8,%esp
  101c36:	50                   	push   %eax
  101c37:	68 4d 3b 10 00       	push   $0x103b4d
  101c3c:	e8 34 e6 ff ff       	call   100275 <cprintf>
  101c41:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c44:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101c48:	d1 65 f0             	shll   -0x10(%ebp)
  101c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c4e:	83 f8 17             	cmp    $0x17,%eax
  101c51:	76 b9                	jbe    101c0c <print_trapframe+0x132>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c53:	8b 45 08             	mov    0x8(%ebp),%eax
  101c56:	8b 40 40             	mov    0x40(%eax),%eax
  101c59:	c1 e8 0c             	shr    $0xc,%eax
  101c5c:	83 e0 03             	and    $0x3,%eax
  101c5f:	83 ec 08             	sub    $0x8,%esp
  101c62:	50                   	push   %eax
  101c63:	68 51 3b 10 00       	push   $0x103b51
  101c68:	e8 08 e6 ff ff       	call   100275 <cprintf>
  101c6d:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101c70:	83 ec 0c             	sub    $0xc,%esp
  101c73:	ff 75 08             	pushl  0x8(%ebp)
  101c76:	e8 45 fe ff ff       	call   101ac0 <trap_in_kernel>
  101c7b:	83 c4 10             	add    $0x10,%esp
  101c7e:	85 c0                	test   %eax,%eax
  101c80:	75 32                	jne    101cb4 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c82:	8b 45 08             	mov    0x8(%ebp),%eax
  101c85:	8b 40 44             	mov    0x44(%eax),%eax
  101c88:	83 ec 08             	sub    $0x8,%esp
  101c8b:	50                   	push   %eax
  101c8c:	68 5a 3b 10 00       	push   $0x103b5a
  101c91:	e8 df e5 ff ff       	call   100275 <cprintf>
  101c96:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c99:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9c:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101ca0:	0f b7 c0             	movzwl %ax,%eax
  101ca3:	83 ec 08             	sub    $0x8,%esp
  101ca6:	50                   	push   %eax
  101ca7:	68 69 3b 10 00       	push   $0x103b69
  101cac:	e8 c4 e5 ff ff       	call   100275 <cprintf>
  101cb1:	83 c4 10             	add    $0x10,%esp
    }
}
  101cb4:	90                   	nop
  101cb5:	c9                   	leave  
  101cb6:	c3                   	ret    

00101cb7 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101cb7:	f3 0f 1e fb          	endbr32 
  101cbb:	55                   	push   %ebp
  101cbc:	89 e5                	mov    %esp,%ebp
  101cbe:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc4:	8b 00                	mov    (%eax),%eax
  101cc6:	83 ec 08             	sub    $0x8,%esp
  101cc9:	50                   	push   %eax
  101cca:	68 7c 3b 10 00       	push   $0x103b7c
  101ccf:	e8 a1 e5 ff ff       	call   100275 <cprintf>
  101cd4:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101cda:	8b 40 04             	mov    0x4(%eax),%eax
  101cdd:	83 ec 08             	sub    $0x8,%esp
  101ce0:	50                   	push   %eax
  101ce1:	68 8b 3b 10 00       	push   $0x103b8b
  101ce6:	e8 8a e5 ff ff       	call   100275 <cprintf>
  101ceb:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101cee:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf1:	8b 40 08             	mov    0x8(%eax),%eax
  101cf4:	83 ec 08             	sub    $0x8,%esp
  101cf7:	50                   	push   %eax
  101cf8:	68 9a 3b 10 00       	push   $0x103b9a
  101cfd:	e8 73 e5 ff ff       	call   100275 <cprintf>
  101d02:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d05:	8b 45 08             	mov    0x8(%ebp),%eax
  101d08:	8b 40 0c             	mov    0xc(%eax),%eax
  101d0b:	83 ec 08             	sub    $0x8,%esp
  101d0e:	50                   	push   %eax
  101d0f:	68 a9 3b 10 00       	push   $0x103ba9
  101d14:	e8 5c e5 ff ff       	call   100275 <cprintf>
  101d19:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1f:	8b 40 10             	mov    0x10(%eax),%eax
  101d22:	83 ec 08             	sub    $0x8,%esp
  101d25:	50                   	push   %eax
  101d26:	68 b8 3b 10 00       	push   $0x103bb8
  101d2b:	e8 45 e5 ff ff       	call   100275 <cprintf>
  101d30:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d33:	8b 45 08             	mov    0x8(%ebp),%eax
  101d36:	8b 40 14             	mov    0x14(%eax),%eax
  101d39:	83 ec 08             	sub    $0x8,%esp
  101d3c:	50                   	push   %eax
  101d3d:	68 c7 3b 10 00       	push   $0x103bc7
  101d42:	e8 2e e5 ff ff       	call   100275 <cprintf>
  101d47:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d4d:	8b 40 18             	mov    0x18(%eax),%eax
  101d50:	83 ec 08             	sub    $0x8,%esp
  101d53:	50                   	push   %eax
  101d54:	68 d6 3b 10 00       	push   $0x103bd6
  101d59:	e8 17 e5 ff ff       	call   100275 <cprintf>
  101d5e:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d61:	8b 45 08             	mov    0x8(%ebp),%eax
  101d64:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d67:	83 ec 08             	sub    $0x8,%esp
  101d6a:	50                   	push   %eax
  101d6b:	68 e5 3b 10 00       	push   $0x103be5
  101d70:	e8 00 e5 ff ff       	call   100275 <cprintf>
  101d75:	83 c4 10             	add    $0x10,%esp
}
  101d78:	90                   	nop
  101d79:	c9                   	leave  
  101d7a:	c3                   	ret    

00101d7b <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d7b:	f3 0f 1e fb          	endbr32 
  101d7f:	55                   	push   %ebp
  101d80:	89 e5                	mov    %esp,%ebp
  101d82:	57                   	push   %edi
  101d83:	56                   	push   %esi
  101d84:	53                   	push   %ebx
  101d85:	83 ec 1c             	sub    $0x1c,%esp
    char c;

    switch (tf->tf_trapno) {
  101d88:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8b:	8b 40 30             	mov    0x30(%eax),%eax
  101d8e:	83 f8 79             	cmp    $0x79,%eax
  101d91:	0f 84 6e 01 00 00    	je     101f05 <trap_dispatch+0x18a>
  101d97:	83 f8 79             	cmp    $0x79,%eax
  101d9a:	0f 87 db 01 00 00    	ja     101f7b <trap_dispatch+0x200>
  101da0:	83 f8 78             	cmp    $0x78,%eax
  101da3:	0f 84 c0 00 00 00    	je     101e69 <trap_dispatch+0xee>
  101da9:	83 f8 78             	cmp    $0x78,%eax
  101dac:	0f 87 c9 01 00 00    	ja     101f7b <trap_dispatch+0x200>
  101db2:	83 f8 2f             	cmp    $0x2f,%eax
  101db5:	0f 87 c0 01 00 00    	ja     101f7b <trap_dispatch+0x200>
  101dbb:	83 f8 2e             	cmp    $0x2e,%eax
  101dbe:	0f 83 ed 01 00 00    	jae    101fb1 <trap_dispatch+0x236>
  101dc4:	83 f8 24             	cmp    $0x24,%eax
  101dc7:	74 52                	je     101e1b <trap_dispatch+0xa0>
  101dc9:	83 f8 24             	cmp    $0x24,%eax
  101dcc:	0f 87 a9 01 00 00    	ja     101f7b <trap_dispatch+0x200>
  101dd2:	83 f8 20             	cmp    $0x20,%eax
  101dd5:	74 0a                	je     101de1 <trap_dispatch+0x66>
  101dd7:	83 f8 21             	cmp    $0x21,%eax
  101dda:	74 66                	je     101e42 <trap_dispatch+0xc7>
  101ddc:	e9 9a 01 00 00       	jmp    101f7b <trap_dispatch+0x200>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101de1:	a1 08 09 11 00       	mov    0x110908,%eax
  101de6:	83 c0 01             	add    $0x1,%eax
  101de9:	a3 08 09 11 00       	mov    %eax,0x110908
        if (ticks % TICK_NUM == 0) {
  101dee:	8b 0d 08 09 11 00    	mov    0x110908,%ecx
  101df4:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101df9:	89 c8                	mov    %ecx,%eax
  101dfb:	f7 e2                	mul    %edx
  101dfd:	89 d0                	mov    %edx,%eax
  101dff:	c1 e8 05             	shr    $0x5,%eax
  101e02:	6b c0 64             	imul   $0x64,%eax,%eax
  101e05:	29 c1                	sub    %eax,%ecx
  101e07:	89 c8                	mov    %ecx,%eax
  101e09:	85 c0                	test   %eax,%eax
  101e0b:	0f 85 a3 01 00 00    	jne    101fb4 <trap_dispatch+0x239>
            print_ticks();
  101e11:	e8 df fa ff ff       	call   1018f5 <print_ticks>
        }
        break;
  101e16:	e9 99 01 00 00       	jmp    101fb4 <trap_dispatch+0x239>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e1b:	e8 7e f8 ff ff       	call   10169e <cons_getc>
  101e20:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e23:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101e27:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e2b:	83 ec 04             	sub    $0x4,%esp
  101e2e:	52                   	push   %edx
  101e2f:	50                   	push   %eax
  101e30:	68 f4 3b 10 00       	push   $0x103bf4
  101e35:	e8 3b e4 ff ff       	call   100275 <cprintf>
  101e3a:	83 c4 10             	add    $0x10,%esp
        break;
  101e3d:	e9 79 01 00 00       	jmp    101fbb <trap_dispatch+0x240>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e42:	e8 57 f8 ff ff       	call   10169e <cons_getc>
  101e47:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e4a:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101e4e:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e52:	83 ec 04             	sub    $0x4,%esp
  101e55:	52                   	push   %edx
  101e56:	50                   	push   %eax
  101e57:	68 06 3c 10 00       	push   $0x103c06
  101e5c:	e8 14 e4 ff ff       	call   100275 <cprintf>
  101e61:	83 c4 10             	add    $0x10,%esp
        break;
  101e64:	e9 52 01 00 00       	jmp    101fbb <trap_dispatch+0x240>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101e69:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e70:	66 83 f8 1b          	cmp    $0x1b,%ax
  101e74:	0f 84 3d 01 00 00    	je     101fb7 <trap_dispatch+0x23c>
            switchk2u = *tf;
  101e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  101e7d:	b8 20 09 11 00       	mov    $0x110920,%eax
  101e82:	89 d3                	mov    %edx,%ebx
  101e84:	ba 4c 00 00 00       	mov    $0x4c,%edx
  101e89:	8b 0b                	mov    (%ebx),%ecx
  101e8b:	89 08                	mov    %ecx,(%eax)
  101e8d:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
  101e91:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  101e95:	8d 78 04             	lea    0x4(%eax),%edi
  101e98:	83 e7 fc             	and    $0xfffffffc,%edi
  101e9b:	29 f8                	sub    %edi,%eax
  101e9d:	29 c3                	sub    %eax,%ebx
  101e9f:	01 c2                	add    %eax,%edx
  101ea1:	83 e2 fc             	and    $0xfffffffc,%edx
  101ea4:	89 d0                	mov    %edx,%eax
  101ea6:	c1 e8 02             	shr    $0x2,%eax
  101ea9:	89 de                	mov    %ebx,%esi
  101eab:	89 c1                	mov    %eax,%ecx
  101ead:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101eaf:	66 c7 05 5c 09 11 00 	movw   $0x1b,0x11095c
  101eb6:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101eb8:	66 c7 05 68 09 11 00 	movw   $0x23,0x110968
  101ebf:	23 00 
  101ec1:	0f b7 05 68 09 11 00 	movzwl 0x110968,%eax
  101ec8:	66 a3 48 09 11 00    	mov    %ax,0x110948
  101ece:	0f b7 05 48 09 11 00 	movzwl 0x110948,%eax
  101ed5:	66 a3 4c 09 11 00    	mov    %ax,0x11094c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101edb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ede:	83 c0 44             	add    $0x44,%eax
  101ee1:	a3 64 09 11 00       	mov    %eax,0x110964
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101ee6:	a1 60 09 11 00       	mov    0x110960,%eax
  101eeb:	80 cc 30             	or     $0x30,%ah
  101eee:	a3 60 09 11 00       	mov    %eax,0x110960
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef6:	83 e8 04             	sub    $0x4,%eax
  101ef9:	ba 20 09 11 00       	mov    $0x110920,%edx
  101efe:	89 10                	mov    %edx,(%eax)
        }
        break;
  101f00:	e9 b2 00 00 00       	jmp    101fb7 <trap_dispatch+0x23c>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101f05:	8b 45 08             	mov    0x8(%ebp),%eax
  101f08:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f0c:	66 83 f8 08          	cmp    $0x8,%ax
  101f10:	0f 84 a4 00 00 00    	je     101fba <trap_dispatch+0x23f>
            tf->tf_cs = KERNEL_CS;
  101f16:	8b 45 08             	mov    0x8(%ebp),%eax
  101f19:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f22:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101f28:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2b:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f32:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101f36:	8b 45 08             	mov    0x8(%ebp),%eax
  101f39:	8b 40 40             	mov    0x40(%eax),%eax
  101f3c:	80 e4 cf             	and    $0xcf,%ah
  101f3f:	89 c2                	mov    %eax,%edx
  101f41:	8b 45 08             	mov    0x8(%ebp),%eax
  101f44:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101f47:	8b 45 08             	mov    0x8(%ebp),%eax
  101f4a:	8b 40 44             	mov    0x44(%eax),%eax
  101f4d:	83 e8 44             	sub    $0x44,%eax
  101f50:	a3 6c 09 11 00       	mov    %eax,0x11096c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101f55:	a1 6c 09 11 00       	mov    0x11096c,%eax
  101f5a:	83 ec 04             	sub    $0x4,%esp
  101f5d:	6a 44                	push   $0x44
  101f5f:	ff 75 08             	pushl  0x8(%ebp)
  101f62:	50                   	push   %eax
  101f63:	e8 eb 0f 00 00       	call   102f53 <memmove>
  101f68:	83 c4 10             	add    $0x10,%esp
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101f6b:	8b 15 6c 09 11 00    	mov    0x11096c,%edx
  101f71:	8b 45 08             	mov    0x8(%ebp),%eax
  101f74:	83 e8 04             	sub    $0x4,%eax
  101f77:	89 10                	mov    %edx,(%eax)
        }
        break;
  101f79:	eb 3f                	jmp    101fba <trap_dispatch+0x23f>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f7e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f82:	0f b7 c0             	movzwl %ax,%eax
  101f85:	83 e0 03             	and    $0x3,%eax
  101f88:	85 c0                	test   %eax,%eax
  101f8a:	75 2f                	jne    101fbb <trap_dispatch+0x240>
            print_trapframe(tf);
  101f8c:	83 ec 0c             	sub    $0xc,%esp
  101f8f:	ff 75 08             	pushl  0x8(%ebp)
  101f92:	e8 43 fb ff ff       	call   101ada <print_trapframe>
  101f97:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101f9a:	83 ec 04             	sub    $0x4,%esp
  101f9d:	68 15 3c 10 00       	push   $0x103c15
  101fa2:	68 d2 00 00 00       	push   $0xd2
  101fa7:	68 31 3c 10 00       	push   $0x103c31
  101fac:	e8 3f e4 ff ff       	call   1003f0 <__panic>
        break;
  101fb1:	90                   	nop
  101fb2:	eb 07                	jmp    101fbb <trap_dispatch+0x240>
        break;
  101fb4:	90                   	nop
  101fb5:	eb 04                	jmp    101fbb <trap_dispatch+0x240>
        break;
  101fb7:	90                   	nop
  101fb8:	eb 01                	jmp    101fbb <trap_dispatch+0x240>
        break;
  101fba:	90                   	nop
        }
    }
}
  101fbb:	90                   	nop
  101fbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  101fbf:	5b                   	pop    %ebx
  101fc0:	5e                   	pop    %esi
  101fc1:	5f                   	pop    %edi
  101fc2:	5d                   	pop    %ebp
  101fc3:	c3                   	ret    

00101fc4 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101fc4:	f3 0f 1e fb          	endbr32 
  101fc8:	55                   	push   %ebp
  101fc9:	89 e5                	mov    %esp,%ebp
  101fcb:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101fce:	83 ec 0c             	sub    $0xc,%esp
  101fd1:	ff 75 08             	pushl  0x8(%ebp)
  101fd4:	e8 a2 fd ff ff       	call   101d7b <trap_dispatch>
  101fd9:	83 c4 10             	add    $0x10,%esp
}
  101fdc:	90                   	nop
  101fdd:	c9                   	leave  
  101fde:	c3                   	ret    

00101fdf <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $0
  101fe1:	6a 00                	push   $0x0
  jmp __alltraps
  101fe3:	e9 67 0a 00 00       	jmp    102a4f <__alltraps>

00101fe8 <vector1>:
.globl vector1
vector1:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $1
  101fea:	6a 01                	push   $0x1
  jmp __alltraps
  101fec:	e9 5e 0a 00 00       	jmp    102a4f <__alltraps>

00101ff1 <vector2>:
.globl vector2
vector2:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $2
  101ff3:	6a 02                	push   $0x2
  jmp __alltraps
  101ff5:	e9 55 0a 00 00       	jmp    102a4f <__alltraps>

00101ffa <vector3>:
.globl vector3
vector3:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $3
  101ffc:	6a 03                	push   $0x3
  jmp __alltraps
  101ffe:	e9 4c 0a 00 00       	jmp    102a4f <__alltraps>

00102003 <vector4>:
.globl vector4
vector4:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $4
  102005:	6a 04                	push   $0x4
  jmp __alltraps
  102007:	e9 43 0a 00 00       	jmp    102a4f <__alltraps>

0010200c <vector5>:
.globl vector5
vector5:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $5
  10200e:	6a 05                	push   $0x5
  jmp __alltraps
  102010:	e9 3a 0a 00 00       	jmp    102a4f <__alltraps>

00102015 <vector6>:
.globl vector6
vector6:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $6
  102017:	6a 06                	push   $0x6
  jmp __alltraps
  102019:	e9 31 0a 00 00       	jmp    102a4f <__alltraps>

0010201e <vector7>:
.globl vector7
vector7:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $7
  102020:	6a 07                	push   $0x7
  jmp __alltraps
  102022:	e9 28 0a 00 00       	jmp    102a4f <__alltraps>

00102027 <vector8>:
.globl vector8
vector8:
  pushl $8
  102027:	6a 08                	push   $0x8
  jmp __alltraps
  102029:	e9 21 0a 00 00       	jmp    102a4f <__alltraps>

0010202e <vector9>:
.globl vector9
vector9:
  pushl $9
  10202e:	6a 09                	push   $0x9
  jmp __alltraps
  102030:	e9 1a 0a 00 00       	jmp    102a4f <__alltraps>

00102035 <vector10>:
.globl vector10
vector10:
  pushl $10
  102035:	6a 0a                	push   $0xa
  jmp __alltraps
  102037:	e9 13 0a 00 00       	jmp    102a4f <__alltraps>

0010203c <vector11>:
.globl vector11
vector11:
  pushl $11
  10203c:	6a 0b                	push   $0xb
  jmp __alltraps
  10203e:	e9 0c 0a 00 00       	jmp    102a4f <__alltraps>

00102043 <vector12>:
.globl vector12
vector12:
  pushl $12
  102043:	6a 0c                	push   $0xc
  jmp __alltraps
  102045:	e9 05 0a 00 00       	jmp    102a4f <__alltraps>

0010204a <vector13>:
.globl vector13
vector13:
  pushl $13
  10204a:	6a 0d                	push   $0xd
  jmp __alltraps
  10204c:	e9 fe 09 00 00       	jmp    102a4f <__alltraps>

00102051 <vector14>:
.globl vector14
vector14:
  pushl $14
  102051:	6a 0e                	push   $0xe
  jmp __alltraps
  102053:	e9 f7 09 00 00       	jmp    102a4f <__alltraps>

00102058 <vector15>:
.globl vector15
vector15:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $15
  10205a:	6a 0f                	push   $0xf
  jmp __alltraps
  10205c:	e9 ee 09 00 00       	jmp    102a4f <__alltraps>

00102061 <vector16>:
.globl vector16
vector16:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $16
  102063:	6a 10                	push   $0x10
  jmp __alltraps
  102065:	e9 e5 09 00 00       	jmp    102a4f <__alltraps>

0010206a <vector17>:
.globl vector17
vector17:
  pushl $17
  10206a:	6a 11                	push   $0x11
  jmp __alltraps
  10206c:	e9 de 09 00 00       	jmp    102a4f <__alltraps>

00102071 <vector18>:
.globl vector18
vector18:
  pushl $0
  102071:	6a 00                	push   $0x0
  pushl $18
  102073:	6a 12                	push   $0x12
  jmp __alltraps
  102075:	e9 d5 09 00 00       	jmp    102a4f <__alltraps>

0010207a <vector19>:
.globl vector19
vector19:
  pushl $0
  10207a:	6a 00                	push   $0x0
  pushl $19
  10207c:	6a 13                	push   $0x13
  jmp __alltraps
  10207e:	e9 cc 09 00 00       	jmp    102a4f <__alltraps>

00102083 <vector20>:
.globl vector20
vector20:
  pushl $0
  102083:	6a 00                	push   $0x0
  pushl $20
  102085:	6a 14                	push   $0x14
  jmp __alltraps
  102087:	e9 c3 09 00 00       	jmp    102a4f <__alltraps>

0010208c <vector21>:
.globl vector21
vector21:
  pushl $0
  10208c:	6a 00                	push   $0x0
  pushl $21
  10208e:	6a 15                	push   $0x15
  jmp __alltraps
  102090:	e9 ba 09 00 00       	jmp    102a4f <__alltraps>

00102095 <vector22>:
.globl vector22
vector22:
  pushl $0
  102095:	6a 00                	push   $0x0
  pushl $22
  102097:	6a 16                	push   $0x16
  jmp __alltraps
  102099:	e9 b1 09 00 00       	jmp    102a4f <__alltraps>

0010209e <vector23>:
.globl vector23
vector23:
  pushl $0
  10209e:	6a 00                	push   $0x0
  pushl $23
  1020a0:	6a 17                	push   $0x17
  jmp __alltraps
  1020a2:	e9 a8 09 00 00       	jmp    102a4f <__alltraps>

001020a7 <vector24>:
.globl vector24
vector24:
  pushl $0
  1020a7:	6a 00                	push   $0x0
  pushl $24
  1020a9:	6a 18                	push   $0x18
  jmp __alltraps
  1020ab:	e9 9f 09 00 00       	jmp    102a4f <__alltraps>

001020b0 <vector25>:
.globl vector25
vector25:
  pushl $0
  1020b0:	6a 00                	push   $0x0
  pushl $25
  1020b2:	6a 19                	push   $0x19
  jmp __alltraps
  1020b4:	e9 96 09 00 00       	jmp    102a4f <__alltraps>

001020b9 <vector26>:
.globl vector26
vector26:
  pushl $0
  1020b9:	6a 00                	push   $0x0
  pushl $26
  1020bb:	6a 1a                	push   $0x1a
  jmp __alltraps
  1020bd:	e9 8d 09 00 00       	jmp    102a4f <__alltraps>

001020c2 <vector27>:
.globl vector27
vector27:
  pushl $0
  1020c2:	6a 00                	push   $0x0
  pushl $27
  1020c4:	6a 1b                	push   $0x1b
  jmp __alltraps
  1020c6:	e9 84 09 00 00       	jmp    102a4f <__alltraps>

001020cb <vector28>:
.globl vector28
vector28:
  pushl $0
  1020cb:	6a 00                	push   $0x0
  pushl $28
  1020cd:	6a 1c                	push   $0x1c
  jmp __alltraps
  1020cf:	e9 7b 09 00 00       	jmp    102a4f <__alltraps>

001020d4 <vector29>:
.globl vector29
vector29:
  pushl $0
  1020d4:	6a 00                	push   $0x0
  pushl $29
  1020d6:	6a 1d                	push   $0x1d
  jmp __alltraps
  1020d8:	e9 72 09 00 00       	jmp    102a4f <__alltraps>

001020dd <vector30>:
.globl vector30
vector30:
  pushl $0
  1020dd:	6a 00                	push   $0x0
  pushl $30
  1020df:	6a 1e                	push   $0x1e
  jmp __alltraps
  1020e1:	e9 69 09 00 00       	jmp    102a4f <__alltraps>

001020e6 <vector31>:
.globl vector31
vector31:
  pushl $0
  1020e6:	6a 00                	push   $0x0
  pushl $31
  1020e8:	6a 1f                	push   $0x1f
  jmp __alltraps
  1020ea:	e9 60 09 00 00       	jmp    102a4f <__alltraps>

001020ef <vector32>:
.globl vector32
vector32:
  pushl $0
  1020ef:	6a 00                	push   $0x0
  pushl $32
  1020f1:	6a 20                	push   $0x20
  jmp __alltraps
  1020f3:	e9 57 09 00 00       	jmp    102a4f <__alltraps>

001020f8 <vector33>:
.globl vector33
vector33:
  pushl $0
  1020f8:	6a 00                	push   $0x0
  pushl $33
  1020fa:	6a 21                	push   $0x21
  jmp __alltraps
  1020fc:	e9 4e 09 00 00       	jmp    102a4f <__alltraps>

00102101 <vector34>:
.globl vector34
vector34:
  pushl $0
  102101:	6a 00                	push   $0x0
  pushl $34
  102103:	6a 22                	push   $0x22
  jmp __alltraps
  102105:	e9 45 09 00 00       	jmp    102a4f <__alltraps>

0010210a <vector35>:
.globl vector35
vector35:
  pushl $0
  10210a:	6a 00                	push   $0x0
  pushl $35
  10210c:	6a 23                	push   $0x23
  jmp __alltraps
  10210e:	e9 3c 09 00 00       	jmp    102a4f <__alltraps>

00102113 <vector36>:
.globl vector36
vector36:
  pushl $0
  102113:	6a 00                	push   $0x0
  pushl $36
  102115:	6a 24                	push   $0x24
  jmp __alltraps
  102117:	e9 33 09 00 00       	jmp    102a4f <__alltraps>

0010211c <vector37>:
.globl vector37
vector37:
  pushl $0
  10211c:	6a 00                	push   $0x0
  pushl $37
  10211e:	6a 25                	push   $0x25
  jmp __alltraps
  102120:	e9 2a 09 00 00       	jmp    102a4f <__alltraps>

00102125 <vector38>:
.globl vector38
vector38:
  pushl $0
  102125:	6a 00                	push   $0x0
  pushl $38
  102127:	6a 26                	push   $0x26
  jmp __alltraps
  102129:	e9 21 09 00 00       	jmp    102a4f <__alltraps>

0010212e <vector39>:
.globl vector39
vector39:
  pushl $0
  10212e:	6a 00                	push   $0x0
  pushl $39
  102130:	6a 27                	push   $0x27
  jmp __alltraps
  102132:	e9 18 09 00 00       	jmp    102a4f <__alltraps>

00102137 <vector40>:
.globl vector40
vector40:
  pushl $0
  102137:	6a 00                	push   $0x0
  pushl $40
  102139:	6a 28                	push   $0x28
  jmp __alltraps
  10213b:	e9 0f 09 00 00       	jmp    102a4f <__alltraps>

00102140 <vector41>:
.globl vector41
vector41:
  pushl $0
  102140:	6a 00                	push   $0x0
  pushl $41
  102142:	6a 29                	push   $0x29
  jmp __alltraps
  102144:	e9 06 09 00 00       	jmp    102a4f <__alltraps>

00102149 <vector42>:
.globl vector42
vector42:
  pushl $0
  102149:	6a 00                	push   $0x0
  pushl $42
  10214b:	6a 2a                	push   $0x2a
  jmp __alltraps
  10214d:	e9 fd 08 00 00       	jmp    102a4f <__alltraps>

00102152 <vector43>:
.globl vector43
vector43:
  pushl $0
  102152:	6a 00                	push   $0x0
  pushl $43
  102154:	6a 2b                	push   $0x2b
  jmp __alltraps
  102156:	e9 f4 08 00 00       	jmp    102a4f <__alltraps>

0010215b <vector44>:
.globl vector44
vector44:
  pushl $0
  10215b:	6a 00                	push   $0x0
  pushl $44
  10215d:	6a 2c                	push   $0x2c
  jmp __alltraps
  10215f:	e9 eb 08 00 00       	jmp    102a4f <__alltraps>

00102164 <vector45>:
.globl vector45
vector45:
  pushl $0
  102164:	6a 00                	push   $0x0
  pushl $45
  102166:	6a 2d                	push   $0x2d
  jmp __alltraps
  102168:	e9 e2 08 00 00       	jmp    102a4f <__alltraps>

0010216d <vector46>:
.globl vector46
vector46:
  pushl $0
  10216d:	6a 00                	push   $0x0
  pushl $46
  10216f:	6a 2e                	push   $0x2e
  jmp __alltraps
  102171:	e9 d9 08 00 00       	jmp    102a4f <__alltraps>

00102176 <vector47>:
.globl vector47
vector47:
  pushl $0
  102176:	6a 00                	push   $0x0
  pushl $47
  102178:	6a 2f                	push   $0x2f
  jmp __alltraps
  10217a:	e9 d0 08 00 00       	jmp    102a4f <__alltraps>

0010217f <vector48>:
.globl vector48
vector48:
  pushl $0
  10217f:	6a 00                	push   $0x0
  pushl $48
  102181:	6a 30                	push   $0x30
  jmp __alltraps
  102183:	e9 c7 08 00 00       	jmp    102a4f <__alltraps>

00102188 <vector49>:
.globl vector49
vector49:
  pushl $0
  102188:	6a 00                	push   $0x0
  pushl $49
  10218a:	6a 31                	push   $0x31
  jmp __alltraps
  10218c:	e9 be 08 00 00       	jmp    102a4f <__alltraps>

00102191 <vector50>:
.globl vector50
vector50:
  pushl $0
  102191:	6a 00                	push   $0x0
  pushl $50
  102193:	6a 32                	push   $0x32
  jmp __alltraps
  102195:	e9 b5 08 00 00       	jmp    102a4f <__alltraps>

0010219a <vector51>:
.globl vector51
vector51:
  pushl $0
  10219a:	6a 00                	push   $0x0
  pushl $51
  10219c:	6a 33                	push   $0x33
  jmp __alltraps
  10219e:	e9 ac 08 00 00       	jmp    102a4f <__alltraps>

001021a3 <vector52>:
.globl vector52
vector52:
  pushl $0
  1021a3:	6a 00                	push   $0x0
  pushl $52
  1021a5:	6a 34                	push   $0x34
  jmp __alltraps
  1021a7:	e9 a3 08 00 00       	jmp    102a4f <__alltraps>

001021ac <vector53>:
.globl vector53
vector53:
  pushl $0
  1021ac:	6a 00                	push   $0x0
  pushl $53
  1021ae:	6a 35                	push   $0x35
  jmp __alltraps
  1021b0:	e9 9a 08 00 00       	jmp    102a4f <__alltraps>

001021b5 <vector54>:
.globl vector54
vector54:
  pushl $0
  1021b5:	6a 00                	push   $0x0
  pushl $54
  1021b7:	6a 36                	push   $0x36
  jmp __alltraps
  1021b9:	e9 91 08 00 00       	jmp    102a4f <__alltraps>

001021be <vector55>:
.globl vector55
vector55:
  pushl $0
  1021be:	6a 00                	push   $0x0
  pushl $55
  1021c0:	6a 37                	push   $0x37
  jmp __alltraps
  1021c2:	e9 88 08 00 00       	jmp    102a4f <__alltraps>

001021c7 <vector56>:
.globl vector56
vector56:
  pushl $0
  1021c7:	6a 00                	push   $0x0
  pushl $56
  1021c9:	6a 38                	push   $0x38
  jmp __alltraps
  1021cb:	e9 7f 08 00 00       	jmp    102a4f <__alltraps>

001021d0 <vector57>:
.globl vector57
vector57:
  pushl $0
  1021d0:	6a 00                	push   $0x0
  pushl $57
  1021d2:	6a 39                	push   $0x39
  jmp __alltraps
  1021d4:	e9 76 08 00 00       	jmp    102a4f <__alltraps>

001021d9 <vector58>:
.globl vector58
vector58:
  pushl $0
  1021d9:	6a 00                	push   $0x0
  pushl $58
  1021db:	6a 3a                	push   $0x3a
  jmp __alltraps
  1021dd:	e9 6d 08 00 00       	jmp    102a4f <__alltraps>

001021e2 <vector59>:
.globl vector59
vector59:
  pushl $0
  1021e2:	6a 00                	push   $0x0
  pushl $59
  1021e4:	6a 3b                	push   $0x3b
  jmp __alltraps
  1021e6:	e9 64 08 00 00       	jmp    102a4f <__alltraps>

001021eb <vector60>:
.globl vector60
vector60:
  pushl $0
  1021eb:	6a 00                	push   $0x0
  pushl $60
  1021ed:	6a 3c                	push   $0x3c
  jmp __alltraps
  1021ef:	e9 5b 08 00 00       	jmp    102a4f <__alltraps>

001021f4 <vector61>:
.globl vector61
vector61:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $61
  1021f6:	6a 3d                	push   $0x3d
  jmp __alltraps
  1021f8:	e9 52 08 00 00       	jmp    102a4f <__alltraps>

001021fd <vector62>:
.globl vector62
vector62:
  pushl $0
  1021fd:	6a 00                	push   $0x0
  pushl $62
  1021ff:	6a 3e                	push   $0x3e
  jmp __alltraps
  102201:	e9 49 08 00 00       	jmp    102a4f <__alltraps>

00102206 <vector63>:
.globl vector63
vector63:
  pushl $0
  102206:	6a 00                	push   $0x0
  pushl $63
  102208:	6a 3f                	push   $0x3f
  jmp __alltraps
  10220a:	e9 40 08 00 00       	jmp    102a4f <__alltraps>

0010220f <vector64>:
.globl vector64
vector64:
  pushl $0
  10220f:	6a 00                	push   $0x0
  pushl $64
  102211:	6a 40                	push   $0x40
  jmp __alltraps
  102213:	e9 37 08 00 00       	jmp    102a4f <__alltraps>

00102218 <vector65>:
.globl vector65
vector65:
  pushl $0
  102218:	6a 00                	push   $0x0
  pushl $65
  10221a:	6a 41                	push   $0x41
  jmp __alltraps
  10221c:	e9 2e 08 00 00       	jmp    102a4f <__alltraps>

00102221 <vector66>:
.globl vector66
vector66:
  pushl $0
  102221:	6a 00                	push   $0x0
  pushl $66
  102223:	6a 42                	push   $0x42
  jmp __alltraps
  102225:	e9 25 08 00 00       	jmp    102a4f <__alltraps>

0010222a <vector67>:
.globl vector67
vector67:
  pushl $0
  10222a:	6a 00                	push   $0x0
  pushl $67
  10222c:	6a 43                	push   $0x43
  jmp __alltraps
  10222e:	e9 1c 08 00 00       	jmp    102a4f <__alltraps>

00102233 <vector68>:
.globl vector68
vector68:
  pushl $0
  102233:	6a 00                	push   $0x0
  pushl $68
  102235:	6a 44                	push   $0x44
  jmp __alltraps
  102237:	e9 13 08 00 00       	jmp    102a4f <__alltraps>

0010223c <vector69>:
.globl vector69
vector69:
  pushl $0
  10223c:	6a 00                	push   $0x0
  pushl $69
  10223e:	6a 45                	push   $0x45
  jmp __alltraps
  102240:	e9 0a 08 00 00       	jmp    102a4f <__alltraps>

00102245 <vector70>:
.globl vector70
vector70:
  pushl $0
  102245:	6a 00                	push   $0x0
  pushl $70
  102247:	6a 46                	push   $0x46
  jmp __alltraps
  102249:	e9 01 08 00 00       	jmp    102a4f <__alltraps>

0010224e <vector71>:
.globl vector71
vector71:
  pushl $0
  10224e:	6a 00                	push   $0x0
  pushl $71
  102250:	6a 47                	push   $0x47
  jmp __alltraps
  102252:	e9 f8 07 00 00       	jmp    102a4f <__alltraps>

00102257 <vector72>:
.globl vector72
vector72:
  pushl $0
  102257:	6a 00                	push   $0x0
  pushl $72
  102259:	6a 48                	push   $0x48
  jmp __alltraps
  10225b:	e9 ef 07 00 00       	jmp    102a4f <__alltraps>

00102260 <vector73>:
.globl vector73
vector73:
  pushl $0
  102260:	6a 00                	push   $0x0
  pushl $73
  102262:	6a 49                	push   $0x49
  jmp __alltraps
  102264:	e9 e6 07 00 00       	jmp    102a4f <__alltraps>

00102269 <vector74>:
.globl vector74
vector74:
  pushl $0
  102269:	6a 00                	push   $0x0
  pushl $74
  10226b:	6a 4a                	push   $0x4a
  jmp __alltraps
  10226d:	e9 dd 07 00 00       	jmp    102a4f <__alltraps>

00102272 <vector75>:
.globl vector75
vector75:
  pushl $0
  102272:	6a 00                	push   $0x0
  pushl $75
  102274:	6a 4b                	push   $0x4b
  jmp __alltraps
  102276:	e9 d4 07 00 00       	jmp    102a4f <__alltraps>

0010227b <vector76>:
.globl vector76
vector76:
  pushl $0
  10227b:	6a 00                	push   $0x0
  pushl $76
  10227d:	6a 4c                	push   $0x4c
  jmp __alltraps
  10227f:	e9 cb 07 00 00       	jmp    102a4f <__alltraps>

00102284 <vector77>:
.globl vector77
vector77:
  pushl $0
  102284:	6a 00                	push   $0x0
  pushl $77
  102286:	6a 4d                	push   $0x4d
  jmp __alltraps
  102288:	e9 c2 07 00 00       	jmp    102a4f <__alltraps>

0010228d <vector78>:
.globl vector78
vector78:
  pushl $0
  10228d:	6a 00                	push   $0x0
  pushl $78
  10228f:	6a 4e                	push   $0x4e
  jmp __alltraps
  102291:	e9 b9 07 00 00       	jmp    102a4f <__alltraps>

00102296 <vector79>:
.globl vector79
vector79:
  pushl $0
  102296:	6a 00                	push   $0x0
  pushl $79
  102298:	6a 4f                	push   $0x4f
  jmp __alltraps
  10229a:	e9 b0 07 00 00       	jmp    102a4f <__alltraps>

0010229f <vector80>:
.globl vector80
vector80:
  pushl $0
  10229f:	6a 00                	push   $0x0
  pushl $80
  1022a1:	6a 50                	push   $0x50
  jmp __alltraps
  1022a3:	e9 a7 07 00 00       	jmp    102a4f <__alltraps>

001022a8 <vector81>:
.globl vector81
vector81:
  pushl $0
  1022a8:	6a 00                	push   $0x0
  pushl $81
  1022aa:	6a 51                	push   $0x51
  jmp __alltraps
  1022ac:	e9 9e 07 00 00       	jmp    102a4f <__alltraps>

001022b1 <vector82>:
.globl vector82
vector82:
  pushl $0
  1022b1:	6a 00                	push   $0x0
  pushl $82
  1022b3:	6a 52                	push   $0x52
  jmp __alltraps
  1022b5:	e9 95 07 00 00       	jmp    102a4f <__alltraps>

001022ba <vector83>:
.globl vector83
vector83:
  pushl $0
  1022ba:	6a 00                	push   $0x0
  pushl $83
  1022bc:	6a 53                	push   $0x53
  jmp __alltraps
  1022be:	e9 8c 07 00 00       	jmp    102a4f <__alltraps>

001022c3 <vector84>:
.globl vector84
vector84:
  pushl $0
  1022c3:	6a 00                	push   $0x0
  pushl $84
  1022c5:	6a 54                	push   $0x54
  jmp __alltraps
  1022c7:	e9 83 07 00 00       	jmp    102a4f <__alltraps>

001022cc <vector85>:
.globl vector85
vector85:
  pushl $0
  1022cc:	6a 00                	push   $0x0
  pushl $85
  1022ce:	6a 55                	push   $0x55
  jmp __alltraps
  1022d0:	e9 7a 07 00 00       	jmp    102a4f <__alltraps>

001022d5 <vector86>:
.globl vector86
vector86:
  pushl $0
  1022d5:	6a 00                	push   $0x0
  pushl $86
  1022d7:	6a 56                	push   $0x56
  jmp __alltraps
  1022d9:	e9 71 07 00 00       	jmp    102a4f <__alltraps>

001022de <vector87>:
.globl vector87
vector87:
  pushl $0
  1022de:	6a 00                	push   $0x0
  pushl $87
  1022e0:	6a 57                	push   $0x57
  jmp __alltraps
  1022e2:	e9 68 07 00 00       	jmp    102a4f <__alltraps>

001022e7 <vector88>:
.globl vector88
vector88:
  pushl $0
  1022e7:	6a 00                	push   $0x0
  pushl $88
  1022e9:	6a 58                	push   $0x58
  jmp __alltraps
  1022eb:	e9 5f 07 00 00       	jmp    102a4f <__alltraps>

001022f0 <vector89>:
.globl vector89
vector89:
  pushl $0
  1022f0:	6a 00                	push   $0x0
  pushl $89
  1022f2:	6a 59                	push   $0x59
  jmp __alltraps
  1022f4:	e9 56 07 00 00       	jmp    102a4f <__alltraps>

001022f9 <vector90>:
.globl vector90
vector90:
  pushl $0
  1022f9:	6a 00                	push   $0x0
  pushl $90
  1022fb:	6a 5a                	push   $0x5a
  jmp __alltraps
  1022fd:	e9 4d 07 00 00       	jmp    102a4f <__alltraps>

00102302 <vector91>:
.globl vector91
vector91:
  pushl $0
  102302:	6a 00                	push   $0x0
  pushl $91
  102304:	6a 5b                	push   $0x5b
  jmp __alltraps
  102306:	e9 44 07 00 00       	jmp    102a4f <__alltraps>

0010230b <vector92>:
.globl vector92
vector92:
  pushl $0
  10230b:	6a 00                	push   $0x0
  pushl $92
  10230d:	6a 5c                	push   $0x5c
  jmp __alltraps
  10230f:	e9 3b 07 00 00       	jmp    102a4f <__alltraps>

00102314 <vector93>:
.globl vector93
vector93:
  pushl $0
  102314:	6a 00                	push   $0x0
  pushl $93
  102316:	6a 5d                	push   $0x5d
  jmp __alltraps
  102318:	e9 32 07 00 00       	jmp    102a4f <__alltraps>

0010231d <vector94>:
.globl vector94
vector94:
  pushl $0
  10231d:	6a 00                	push   $0x0
  pushl $94
  10231f:	6a 5e                	push   $0x5e
  jmp __alltraps
  102321:	e9 29 07 00 00       	jmp    102a4f <__alltraps>

00102326 <vector95>:
.globl vector95
vector95:
  pushl $0
  102326:	6a 00                	push   $0x0
  pushl $95
  102328:	6a 5f                	push   $0x5f
  jmp __alltraps
  10232a:	e9 20 07 00 00       	jmp    102a4f <__alltraps>

0010232f <vector96>:
.globl vector96
vector96:
  pushl $0
  10232f:	6a 00                	push   $0x0
  pushl $96
  102331:	6a 60                	push   $0x60
  jmp __alltraps
  102333:	e9 17 07 00 00       	jmp    102a4f <__alltraps>

00102338 <vector97>:
.globl vector97
vector97:
  pushl $0
  102338:	6a 00                	push   $0x0
  pushl $97
  10233a:	6a 61                	push   $0x61
  jmp __alltraps
  10233c:	e9 0e 07 00 00       	jmp    102a4f <__alltraps>

00102341 <vector98>:
.globl vector98
vector98:
  pushl $0
  102341:	6a 00                	push   $0x0
  pushl $98
  102343:	6a 62                	push   $0x62
  jmp __alltraps
  102345:	e9 05 07 00 00       	jmp    102a4f <__alltraps>

0010234a <vector99>:
.globl vector99
vector99:
  pushl $0
  10234a:	6a 00                	push   $0x0
  pushl $99
  10234c:	6a 63                	push   $0x63
  jmp __alltraps
  10234e:	e9 fc 06 00 00       	jmp    102a4f <__alltraps>

00102353 <vector100>:
.globl vector100
vector100:
  pushl $0
  102353:	6a 00                	push   $0x0
  pushl $100
  102355:	6a 64                	push   $0x64
  jmp __alltraps
  102357:	e9 f3 06 00 00       	jmp    102a4f <__alltraps>

0010235c <vector101>:
.globl vector101
vector101:
  pushl $0
  10235c:	6a 00                	push   $0x0
  pushl $101
  10235e:	6a 65                	push   $0x65
  jmp __alltraps
  102360:	e9 ea 06 00 00       	jmp    102a4f <__alltraps>

00102365 <vector102>:
.globl vector102
vector102:
  pushl $0
  102365:	6a 00                	push   $0x0
  pushl $102
  102367:	6a 66                	push   $0x66
  jmp __alltraps
  102369:	e9 e1 06 00 00       	jmp    102a4f <__alltraps>

0010236e <vector103>:
.globl vector103
vector103:
  pushl $0
  10236e:	6a 00                	push   $0x0
  pushl $103
  102370:	6a 67                	push   $0x67
  jmp __alltraps
  102372:	e9 d8 06 00 00       	jmp    102a4f <__alltraps>

00102377 <vector104>:
.globl vector104
vector104:
  pushl $0
  102377:	6a 00                	push   $0x0
  pushl $104
  102379:	6a 68                	push   $0x68
  jmp __alltraps
  10237b:	e9 cf 06 00 00       	jmp    102a4f <__alltraps>

00102380 <vector105>:
.globl vector105
vector105:
  pushl $0
  102380:	6a 00                	push   $0x0
  pushl $105
  102382:	6a 69                	push   $0x69
  jmp __alltraps
  102384:	e9 c6 06 00 00       	jmp    102a4f <__alltraps>

00102389 <vector106>:
.globl vector106
vector106:
  pushl $0
  102389:	6a 00                	push   $0x0
  pushl $106
  10238b:	6a 6a                	push   $0x6a
  jmp __alltraps
  10238d:	e9 bd 06 00 00       	jmp    102a4f <__alltraps>

00102392 <vector107>:
.globl vector107
vector107:
  pushl $0
  102392:	6a 00                	push   $0x0
  pushl $107
  102394:	6a 6b                	push   $0x6b
  jmp __alltraps
  102396:	e9 b4 06 00 00       	jmp    102a4f <__alltraps>

0010239b <vector108>:
.globl vector108
vector108:
  pushl $0
  10239b:	6a 00                	push   $0x0
  pushl $108
  10239d:	6a 6c                	push   $0x6c
  jmp __alltraps
  10239f:	e9 ab 06 00 00       	jmp    102a4f <__alltraps>

001023a4 <vector109>:
.globl vector109
vector109:
  pushl $0
  1023a4:	6a 00                	push   $0x0
  pushl $109
  1023a6:	6a 6d                	push   $0x6d
  jmp __alltraps
  1023a8:	e9 a2 06 00 00       	jmp    102a4f <__alltraps>

001023ad <vector110>:
.globl vector110
vector110:
  pushl $0
  1023ad:	6a 00                	push   $0x0
  pushl $110
  1023af:	6a 6e                	push   $0x6e
  jmp __alltraps
  1023b1:	e9 99 06 00 00       	jmp    102a4f <__alltraps>

001023b6 <vector111>:
.globl vector111
vector111:
  pushl $0
  1023b6:	6a 00                	push   $0x0
  pushl $111
  1023b8:	6a 6f                	push   $0x6f
  jmp __alltraps
  1023ba:	e9 90 06 00 00       	jmp    102a4f <__alltraps>

001023bf <vector112>:
.globl vector112
vector112:
  pushl $0
  1023bf:	6a 00                	push   $0x0
  pushl $112
  1023c1:	6a 70                	push   $0x70
  jmp __alltraps
  1023c3:	e9 87 06 00 00       	jmp    102a4f <__alltraps>

001023c8 <vector113>:
.globl vector113
vector113:
  pushl $0
  1023c8:	6a 00                	push   $0x0
  pushl $113
  1023ca:	6a 71                	push   $0x71
  jmp __alltraps
  1023cc:	e9 7e 06 00 00       	jmp    102a4f <__alltraps>

001023d1 <vector114>:
.globl vector114
vector114:
  pushl $0
  1023d1:	6a 00                	push   $0x0
  pushl $114
  1023d3:	6a 72                	push   $0x72
  jmp __alltraps
  1023d5:	e9 75 06 00 00       	jmp    102a4f <__alltraps>

001023da <vector115>:
.globl vector115
vector115:
  pushl $0
  1023da:	6a 00                	push   $0x0
  pushl $115
  1023dc:	6a 73                	push   $0x73
  jmp __alltraps
  1023de:	e9 6c 06 00 00       	jmp    102a4f <__alltraps>

001023e3 <vector116>:
.globl vector116
vector116:
  pushl $0
  1023e3:	6a 00                	push   $0x0
  pushl $116
  1023e5:	6a 74                	push   $0x74
  jmp __alltraps
  1023e7:	e9 63 06 00 00       	jmp    102a4f <__alltraps>

001023ec <vector117>:
.globl vector117
vector117:
  pushl $0
  1023ec:	6a 00                	push   $0x0
  pushl $117
  1023ee:	6a 75                	push   $0x75
  jmp __alltraps
  1023f0:	e9 5a 06 00 00       	jmp    102a4f <__alltraps>

001023f5 <vector118>:
.globl vector118
vector118:
  pushl $0
  1023f5:	6a 00                	push   $0x0
  pushl $118
  1023f7:	6a 76                	push   $0x76
  jmp __alltraps
  1023f9:	e9 51 06 00 00       	jmp    102a4f <__alltraps>

001023fe <vector119>:
.globl vector119
vector119:
  pushl $0
  1023fe:	6a 00                	push   $0x0
  pushl $119
  102400:	6a 77                	push   $0x77
  jmp __alltraps
  102402:	e9 48 06 00 00       	jmp    102a4f <__alltraps>

00102407 <vector120>:
.globl vector120
vector120:
  pushl $0
  102407:	6a 00                	push   $0x0
  pushl $120
  102409:	6a 78                	push   $0x78
  jmp __alltraps
  10240b:	e9 3f 06 00 00       	jmp    102a4f <__alltraps>

00102410 <vector121>:
.globl vector121
vector121:
  pushl $0
  102410:	6a 00                	push   $0x0
  pushl $121
  102412:	6a 79                	push   $0x79
  jmp __alltraps
  102414:	e9 36 06 00 00       	jmp    102a4f <__alltraps>

00102419 <vector122>:
.globl vector122
vector122:
  pushl $0
  102419:	6a 00                	push   $0x0
  pushl $122
  10241b:	6a 7a                	push   $0x7a
  jmp __alltraps
  10241d:	e9 2d 06 00 00       	jmp    102a4f <__alltraps>

00102422 <vector123>:
.globl vector123
vector123:
  pushl $0
  102422:	6a 00                	push   $0x0
  pushl $123
  102424:	6a 7b                	push   $0x7b
  jmp __alltraps
  102426:	e9 24 06 00 00       	jmp    102a4f <__alltraps>

0010242b <vector124>:
.globl vector124
vector124:
  pushl $0
  10242b:	6a 00                	push   $0x0
  pushl $124
  10242d:	6a 7c                	push   $0x7c
  jmp __alltraps
  10242f:	e9 1b 06 00 00       	jmp    102a4f <__alltraps>

00102434 <vector125>:
.globl vector125
vector125:
  pushl $0
  102434:	6a 00                	push   $0x0
  pushl $125
  102436:	6a 7d                	push   $0x7d
  jmp __alltraps
  102438:	e9 12 06 00 00       	jmp    102a4f <__alltraps>

0010243d <vector126>:
.globl vector126
vector126:
  pushl $0
  10243d:	6a 00                	push   $0x0
  pushl $126
  10243f:	6a 7e                	push   $0x7e
  jmp __alltraps
  102441:	e9 09 06 00 00       	jmp    102a4f <__alltraps>

00102446 <vector127>:
.globl vector127
vector127:
  pushl $0
  102446:	6a 00                	push   $0x0
  pushl $127
  102448:	6a 7f                	push   $0x7f
  jmp __alltraps
  10244a:	e9 00 06 00 00       	jmp    102a4f <__alltraps>

0010244f <vector128>:
.globl vector128
vector128:
  pushl $0
  10244f:	6a 00                	push   $0x0
  pushl $128
  102451:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102456:	e9 f4 05 00 00       	jmp    102a4f <__alltraps>

0010245b <vector129>:
.globl vector129
vector129:
  pushl $0
  10245b:	6a 00                	push   $0x0
  pushl $129
  10245d:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102462:	e9 e8 05 00 00       	jmp    102a4f <__alltraps>

00102467 <vector130>:
.globl vector130
vector130:
  pushl $0
  102467:	6a 00                	push   $0x0
  pushl $130
  102469:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10246e:	e9 dc 05 00 00       	jmp    102a4f <__alltraps>

00102473 <vector131>:
.globl vector131
vector131:
  pushl $0
  102473:	6a 00                	push   $0x0
  pushl $131
  102475:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10247a:	e9 d0 05 00 00       	jmp    102a4f <__alltraps>

0010247f <vector132>:
.globl vector132
vector132:
  pushl $0
  10247f:	6a 00                	push   $0x0
  pushl $132
  102481:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102486:	e9 c4 05 00 00       	jmp    102a4f <__alltraps>

0010248b <vector133>:
.globl vector133
vector133:
  pushl $0
  10248b:	6a 00                	push   $0x0
  pushl $133
  10248d:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102492:	e9 b8 05 00 00       	jmp    102a4f <__alltraps>

00102497 <vector134>:
.globl vector134
vector134:
  pushl $0
  102497:	6a 00                	push   $0x0
  pushl $134
  102499:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10249e:	e9 ac 05 00 00       	jmp    102a4f <__alltraps>

001024a3 <vector135>:
.globl vector135
vector135:
  pushl $0
  1024a3:	6a 00                	push   $0x0
  pushl $135
  1024a5:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1024aa:	e9 a0 05 00 00       	jmp    102a4f <__alltraps>

001024af <vector136>:
.globl vector136
vector136:
  pushl $0
  1024af:	6a 00                	push   $0x0
  pushl $136
  1024b1:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1024b6:	e9 94 05 00 00       	jmp    102a4f <__alltraps>

001024bb <vector137>:
.globl vector137
vector137:
  pushl $0
  1024bb:	6a 00                	push   $0x0
  pushl $137
  1024bd:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1024c2:	e9 88 05 00 00       	jmp    102a4f <__alltraps>

001024c7 <vector138>:
.globl vector138
vector138:
  pushl $0
  1024c7:	6a 00                	push   $0x0
  pushl $138
  1024c9:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1024ce:	e9 7c 05 00 00       	jmp    102a4f <__alltraps>

001024d3 <vector139>:
.globl vector139
vector139:
  pushl $0
  1024d3:	6a 00                	push   $0x0
  pushl $139
  1024d5:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1024da:	e9 70 05 00 00       	jmp    102a4f <__alltraps>

001024df <vector140>:
.globl vector140
vector140:
  pushl $0
  1024df:	6a 00                	push   $0x0
  pushl $140
  1024e1:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1024e6:	e9 64 05 00 00       	jmp    102a4f <__alltraps>

001024eb <vector141>:
.globl vector141
vector141:
  pushl $0
  1024eb:	6a 00                	push   $0x0
  pushl $141
  1024ed:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1024f2:	e9 58 05 00 00       	jmp    102a4f <__alltraps>

001024f7 <vector142>:
.globl vector142
vector142:
  pushl $0
  1024f7:	6a 00                	push   $0x0
  pushl $142
  1024f9:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1024fe:	e9 4c 05 00 00       	jmp    102a4f <__alltraps>

00102503 <vector143>:
.globl vector143
vector143:
  pushl $0
  102503:	6a 00                	push   $0x0
  pushl $143
  102505:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10250a:	e9 40 05 00 00       	jmp    102a4f <__alltraps>

0010250f <vector144>:
.globl vector144
vector144:
  pushl $0
  10250f:	6a 00                	push   $0x0
  pushl $144
  102511:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102516:	e9 34 05 00 00       	jmp    102a4f <__alltraps>

0010251b <vector145>:
.globl vector145
vector145:
  pushl $0
  10251b:	6a 00                	push   $0x0
  pushl $145
  10251d:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102522:	e9 28 05 00 00       	jmp    102a4f <__alltraps>

00102527 <vector146>:
.globl vector146
vector146:
  pushl $0
  102527:	6a 00                	push   $0x0
  pushl $146
  102529:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10252e:	e9 1c 05 00 00       	jmp    102a4f <__alltraps>

00102533 <vector147>:
.globl vector147
vector147:
  pushl $0
  102533:	6a 00                	push   $0x0
  pushl $147
  102535:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10253a:	e9 10 05 00 00       	jmp    102a4f <__alltraps>

0010253f <vector148>:
.globl vector148
vector148:
  pushl $0
  10253f:	6a 00                	push   $0x0
  pushl $148
  102541:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102546:	e9 04 05 00 00       	jmp    102a4f <__alltraps>

0010254b <vector149>:
.globl vector149
vector149:
  pushl $0
  10254b:	6a 00                	push   $0x0
  pushl $149
  10254d:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102552:	e9 f8 04 00 00       	jmp    102a4f <__alltraps>

00102557 <vector150>:
.globl vector150
vector150:
  pushl $0
  102557:	6a 00                	push   $0x0
  pushl $150
  102559:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10255e:	e9 ec 04 00 00       	jmp    102a4f <__alltraps>

00102563 <vector151>:
.globl vector151
vector151:
  pushl $0
  102563:	6a 00                	push   $0x0
  pushl $151
  102565:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10256a:	e9 e0 04 00 00       	jmp    102a4f <__alltraps>

0010256f <vector152>:
.globl vector152
vector152:
  pushl $0
  10256f:	6a 00                	push   $0x0
  pushl $152
  102571:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102576:	e9 d4 04 00 00       	jmp    102a4f <__alltraps>

0010257b <vector153>:
.globl vector153
vector153:
  pushl $0
  10257b:	6a 00                	push   $0x0
  pushl $153
  10257d:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102582:	e9 c8 04 00 00       	jmp    102a4f <__alltraps>

00102587 <vector154>:
.globl vector154
vector154:
  pushl $0
  102587:	6a 00                	push   $0x0
  pushl $154
  102589:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10258e:	e9 bc 04 00 00       	jmp    102a4f <__alltraps>

00102593 <vector155>:
.globl vector155
vector155:
  pushl $0
  102593:	6a 00                	push   $0x0
  pushl $155
  102595:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10259a:	e9 b0 04 00 00       	jmp    102a4f <__alltraps>

0010259f <vector156>:
.globl vector156
vector156:
  pushl $0
  10259f:	6a 00                	push   $0x0
  pushl $156
  1025a1:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1025a6:	e9 a4 04 00 00       	jmp    102a4f <__alltraps>

001025ab <vector157>:
.globl vector157
vector157:
  pushl $0
  1025ab:	6a 00                	push   $0x0
  pushl $157
  1025ad:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1025b2:	e9 98 04 00 00       	jmp    102a4f <__alltraps>

001025b7 <vector158>:
.globl vector158
vector158:
  pushl $0
  1025b7:	6a 00                	push   $0x0
  pushl $158
  1025b9:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1025be:	e9 8c 04 00 00       	jmp    102a4f <__alltraps>

001025c3 <vector159>:
.globl vector159
vector159:
  pushl $0
  1025c3:	6a 00                	push   $0x0
  pushl $159
  1025c5:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1025ca:	e9 80 04 00 00       	jmp    102a4f <__alltraps>

001025cf <vector160>:
.globl vector160
vector160:
  pushl $0
  1025cf:	6a 00                	push   $0x0
  pushl $160
  1025d1:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1025d6:	e9 74 04 00 00       	jmp    102a4f <__alltraps>

001025db <vector161>:
.globl vector161
vector161:
  pushl $0
  1025db:	6a 00                	push   $0x0
  pushl $161
  1025dd:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1025e2:	e9 68 04 00 00       	jmp    102a4f <__alltraps>

001025e7 <vector162>:
.globl vector162
vector162:
  pushl $0
  1025e7:	6a 00                	push   $0x0
  pushl $162
  1025e9:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1025ee:	e9 5c 04 00 00       	jmp    102a4f <__alltraps>

001025f3 <vector163>:
.globl vector163
vector163:
  pushl $0
  1025f3:	6a 00                	push   $0x0
  pushl $163
  1025f5:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1025fa:	e9 50 04 00 00       	jmp    102a4f <__alltraps>

001025ff <vector164>:
.globl vector164
vector164:
  pushl $0
  1025ff:	6a 00                	push   $0x0
  pushl $164
  102601:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102606:	e9 44 04 00 00       	jmp    102a4f <__alltraps>

0010260b <vector165>:
.globl vector165
vector165:
  pushl $0
  10260b:	6a 00                	push   $0x0
  pushl $165
  10260d:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102612:	e9 38 04 00 00       	jmp    102a4f <__alltraps>

00102617 <vector166>:
.globl vector166
vector166:
  pushl $0
  102617:	6a 00                	push   $0x0
  pushl $166
  102619:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10261e:	e9 2c 04 00 00       	jmp    102a4f <__alltraps>

00102623 <vector167>:
.globl vector167
vector167:
  pushl $0
  102623:	6a 00                	push   $0x0
  pushl $167
  102625:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10262a:	e9 20 04 00 00       	jmp    102a4f <__alltraps>

0010262f <vector168>:
.globl vector168
vector168:
  pushl $0
  10262f:	6a 00                	push   $0x0
  pushl $168
  102631:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102636:	e9 14 04 00 00       	jmp    102a4f <__alltraps>

0010263b <vector169>:
.globl vector169
vector169:
  pushl $0
  10263b:	6a 00                	push   $0x0
  pushl $169
  10263d:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102642:	e9 08 04 00 00       	jmp    102a4f <__alltraps>

00102647 <vector170>:
.globl vector170
vector170:
  pushl $0
  102647:	6a 00                	push   $0x0
  pushl $170
  102649:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10264e:	e9 fc 03 00 00       	jmp    102a4f <__alltraps>

00102653 <vector171>:
.globl vector171
vector171:
  pushl $0
  102653:	6a 00                	push   $0x0
  pushl $171
  102655:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10265a:	e9 f0 03 00 00       	jmp    102a4f <__alltraps>

0010265f <vector172>:
.globl vector172
vector172:
  pushl $0
  10265f:	6a 00                	push   $0x0
  pushl $172
  102661:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102666:	e9 e4 03 00 00       	jmp    102a4f <__alltraps>

0010266b <vector173>:
.globl vector173
vector173:
  pushl $0
  10266b:	6a 00                	push   $0x0
  pushl $173
  10266d:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102672:	e9 d8 03 00 00       	jmp    102a4f <__alltraps>

00102677 <vector174>:
.globl vector174
vector174:
  pushl $0
  102677:	6a 00                	push   $0x0
  pushl $174
  102679:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10267e:	e9 cc 03 00 00       	jmp    102a4f <__alltraps>

00102683 <vector175>:
.globl vector175
vector175:
  pushl $0
  102683:	6a 00                	push   $0x0
  pushl $175
  102685:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10268a:	e9 c0 03 00 00       	jmp    102a4f <__alltraps>

0010268f <vector176>:
.globl vector176
vector176:
  pushl $0
  10268f:	6a 00                	push   $0x0
  pushl $176
  102691:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102696:	e9 b4 03 00 00       	jmp    102a4f <__alltraps>

0010269b <vector177>:
.globl vector177
vector177:
  pushl $0
  10269b:	6a 00                	push   $0x0
  pushl $177
  10269d:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1026a2:	e9 a8 03 00 00       	jmp    102a4f <__alltraps>

001026a7 <vector178>:
.globl vector178
vector178:
  pushl $0
  1026a7:	6a 00                	push   $0x0
  pushl $178
  1026a9:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1026ae:	e9 9c 03 00 00       	jmp    102a4f <__alltraps>

001026b3 <vector179>:
.globl vector179
vector179:
  pushl $0
  1026b3:	6a 00                	push   $0x0
  pushl $179
  1026b5:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1026ba:	e9 90 03 00 00       	jmp    102a4f <__alltraps>

001026bf <vector180>:
.globl vector180
vector180:
  pushl $0
  1026bf:	6a 00                	push   $0x0
  pushl $180
  1026c1:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1026c6:	e9 84 03 00 00       	jmp    102a4f <__alltraps>

001026cb <vector181>:
.globl vector181
vector181:
  pushl $0
  1026cb:	6a 00                	push   $0x0
  pushl $181
  1026cd:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1026d2:	e9 78 03 00 00       	jmp    102a4f <__alltraps>

001026d7 <vector182>:
.globl vector182
vector182:
  pushl $0
  1026d7:	6a 00                	push   $0x0
  pushl $182
  1026d9:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1026de:	e9 6c 03 00 00       	jmp    102a4f <__alltraps>

001026e3 <vector183>:
.globl vector183
vector183:
  pushl $0
  1026e3:	6a 00                	push   $0x0
  pushl $183
  1026e5:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1026ea:	e9 60 03 00 00       	jmp    102a4f <__alltraps>

001026ef <vector184>:
.globl vector184
vector184:
  pushl $0
  1026ef:	6a 00                	push   $0x0
  pushl $184
  1026f1:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1026f6:	e9 54 03 00 00       	jmp    102a4f <__alltraps>

001026fb <vector185>:
.globl vector185
vector185:
  pushl $0
  1026fb:	6a 00                	push   $0x0
  pushl $185
  1026fd:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102702:	e9 48 03 00 00       	jmp    102a4f <__alltraps>

00102707 <vector186>:
.globl vector186
vector186:
  pushl $0
  102707:	6a 00                	push   $0x0
  pushl $186
  102709:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10270e:	e9 3c 03 00 00       	jmp    102a4f <__alltraps>

00102713 <vector187>:
.globl vector187
vector187:
  pushl $0
  102713:	6a 00                	push   $0x0
  pushl $187
  102715:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10271a:	e9 30 03 00 00       	jmp    102a4f <__alltraps>

0010271f <vector188>:
.globl vector188
vector188:
  pushl $0
  10271f:	6a 00                	push   $0x0
  pushl $188
  102721:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102726:	e9 24 03 00 00       	jmp    102a4f <__alltraps>

0010272b <vector189>:
.globl vector189
vector189:
  pushl $0
  10272b:	6a 00                	push   $0x0
  pushl $189
  10272d:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102732:	e9 18 03 00 00       	jmp    102a4f <__alltraps>

00102737 <vector190>:
.globl vector190
vector190:
  pushl $0
  102737:	6a 00                	push   $0x0
  pushl $190
  102739:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10273e:	e9 0c 03 00 00       	jmp    102a4f <__alltraps>

00102743 <vector191>:
.globl vector191
vector191:
  pushl $0
  102743:	6a 00                	push   $0x0
  pushl $191
  102745:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10274a:	e9 00 03 00 00       	jmp    102a4f <__alltraps>

0010274f <vector192>:
.globl vector192
vector192:
  pushl $0
  10274f:	6a 00                	push   $0x0
  pushl $192
  102751:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102756:	e9 f4 02 00 00       	jmp    102a4f <__alltraps>

0010275b <vector193>:
.globl vector193
vector193:
  pushl $0
  10275b:	6a 00                	push   $0x0
  pushl $193
  10275d:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102762:	e9 e8 02 00 00       	jmp    102a4f <__alltraps>

00102767 <vector194>:
.globl vector194
vector194:
  pushl $0
  102767:	6a 00                	push   $0x0
  pushl $194
  102769:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10276e:	e9 dc 02 00 00       	jmp    102a4f <__alltraps>

00102773 <vector195>:
.globl vector195
vector195:
  pushl $0
  102773:	6a 00                	push   $0x0
  pushl $195
  102775:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10277a:	e9 d0 02 00 00       	jmp    102a4f <__alltraps>

0010277f <vector196>:
.globl vector196
vector196:
  pushl $0
  10277f:	6a 00                	push   $0x0
  pushl $196
  102781:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102786:	e9 c4 02 00 00       	jmp    102a4f <__alltraps>

0010278b <vector197>:
.globl vector197
vector197:
  pushl $0
  10278b:	6a 00                	push   $0x0
  pushl $197
  10278d:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102792:	e9 b8 02 00 00       	jmp    102a4f <__alltraps>

00102797 <vector198>:
.globl vector198
vector198:
  pushl $0
  102797:	6a 00                	push   $0x0
  pushl $198
  102799:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10279e:	e9 ac 02 00 00       	jmp    102a4f <__alltraps>

001027a3 <vector199>:
.globl vector199
vector199:
  pushl $0
  1027a3:	6a 00                	push   $0x0
  pushl $199
  1027a5:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1027aa:	e9 a0 02 00 00       	jmp    102a4f <__alltraps>

001027af <vector200>:
.globl vector200
vector200:
  pushl $0
  1027af:	6a 00                	push   $0x0
  pushl $200
  1027b1:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1027b6:	e9 94 02 00 00       	jmp    102a4f <__alltraps>

001027bb <vector201>:
.globl vector201
vector201:
  pushl $0
  1027bb:	6a 00                	push   $0x0
  pushl $201
  1027bd:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1027c2:	e9 88 02 00 00       	jmp    102a4f <__alltraps>

001027c7 <vector202>:
.globl vector202
vector202:
  pushl $0
  1027c7:	6a 00                	push   $0x0
  pushl $202
  1027c9:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1027ce:	e9 7c 02 00 00       	jmp    102a4f <__alltraps>

001027d3 <vector203>:
.globl vector203
vector203:
  pushl $0
  1027d3:	6a 00                	push   $0x0
  pushl $203
  1027d5:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1027da:	e9 70 02 00 00       	jmp    102a4f <__alltraps>

001027df <vector204>:
.globl vector204
vector204:
  pushl $0
  1027df:	6a 00                	push   $0x0
  pushl $204
  1027e1:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1027e6:	e9 64 02 00 00       	jmp    102a4f <__alltraps>

001027eb <vector205>:
.globl vector205
vector205:
  pushl $0
  1027eb:	6a 00                	push   $0x0
  pushl $205
  1027ed:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1027f2:	e9 58 02 00 00       	jmp    102a4f <__alltraps>

001027f7 <vector206>:
.globl vector206
vector206:
  pushl $0
  1027f7:	6a 00                	push   $0x0
  pushl $206
  1027f9:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1027fe:	e9 4c 02 00 00       	jmp    102a4f <__alltraps>

00102803 <vector207>:
.globl vector207
vector207:
  pushl $0
  102803:	6a 00                	push   $0x0
  pushl $207
  102805:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10280a:	e9 40 02 00 00       	jmp    102a4f <__alltraps>

0010280f <vector208>:
.globl vector208
vector208:
  pushl $0
  10280f:	6a 00                	push   $0x0
  pushl $208
  102811:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102816:	e9 34 02 00 00       	jmp    102a4f <__alltraps>

0010281b <vector209>:
.globl vector209
vector209:
  pushl $0
  10281b:	6a 00                	push   $0x0
  pushl $209
  10281d:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102822:	e9 28 02 00 00       	jmp    102a4f <__alltraps>

00102827 <vector210>:
.globl vector210
vector210:
  pushl $0
  102827:	6a 00                	push   $0x0
  pushl $210
  102829:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10282e:	e9 1c 02 00 00       	jmp    102a4f <__alltraps>

00102833 <vector211>:
.globl vector211
vector211:
  pushl $0
  102833:	6a 00                	push   $0x0
  pushl $211
  102835:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10283a:	e9 10 02 00 00       	jmp    102a4f <__alltraps>

0010283f <vector212>:
.globl vector212
vector212:
  pushl $0
  10283f:	6a 00                	push   $0x0
  pushl $212
  102841:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102846:	e9 04 02 00 00       	jmp    102a4f <__alltraps>

0010284b <vector213>:
.globl vector213
vector213:
  pushl $0
  10284b:	6a 00                	push   $0x0
  pushl $213
  10284d:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102852:	e9 f8 01 00 00       	jmp    102a4f <__alltraps>

00102857 <vector214>:
.globl vector214
vector214:
  pushl $0
  102857:	6a 00                	push   $0x0
  pushl $214
  102859:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10285e:	e9 ec 01 00 00       	jmp    102a4f <__alltraps>

00102863 <vector215>:
.globl vector215
vector215:
  pushl $0
  102863:	6a 00                	push   $0x0
  pushl $215
  102865:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10286a:	e9 e0 01 00 00       	jmp    102a4f <__alltraps>

0010286f <vector216>:
.globl vector216
vector216:
  pushl $0
  10286f:	6a 00                	push   $0x0
  pushl $216
  102871:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102876:	e9 d4 01 00 00       	jmp    102a4f <__alltraps>

0010287b <vector217>:
.globl vector217
vector217:
  pushl $0
  10287b:	6a 00                	push   $0x0
  pushl $217
  10287d:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102882:	e9 c8 01 00 00       	jmp    102a4f <__alltraps>

00102887 <vector218>:
.globl vector218
vector218:
  pushl $0
  102887:	6a 00                	push   $0x0
  pushl $218
  102889:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10288e:	e9 bc 01 00 00       	jmp    102a4f <__alltraps>

00102893 <vector219>:
.globl vector219
vector219:
  pushl $0
  102893:	6a 00                	push   $0x0
  pushl $219
  102895:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10289a:	e9 b0 01 00 00       	jmp    102a4f <__alltraps>

0010289f <vector220>:
.globl vector220
vector220:
  pushl $0
  10289f:	6a 00                	push   $0x0
  pushl $220
  1028a1:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1028a6:	e9 a4 01 00 00       	jmp    102a4f <__alltraps>

001028ab <vector221>:
.globl vector221
vector221:
  pushl $0
  1028ab:	6a 00                	push   $0x0
  pushl $221
  1028ad:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1028b2:	e9 98 01 00 00       	jmp    102a4f <__alltraps>

001028b7 <vector222>:
.globl vector222
vector222:
  pushl $0
  1028b7:	6a 00                	push   $0x0
  pushl $222
  1028b9:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1028be:	e9 8c 01 00 00       	jmp    102a4f <__alltraps>

001028c3 <vector223>:
.globl vector223
vector223:
  pushl $0
  1028c3:	6a 00                	push   $0x0
  pushl $223
  1028c5:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1028ca:	e9 80 01 00 00       	jmp    102a4f <__alltraps>

001028cf <vector224>:
.globl vector224
vector224:
  pushl $0
  1028cf:	6a 00                	push   $0x0
  pushl $224
  1028d1:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1028d6:	e9 74 01 00 00       	jmp    102a4f <__alltraps>

001028db <vector225>:
.globl vector225
vector225:
  pushl $0
  1028db:	6a 00                	push   $0x0
  pushl $225
  1028dd:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1028e2:	e9 68 01 00 00       	jmp    102a4f <__alltraps>

001028e7 <vector226>:
.globl vector226
vector226:
  pushl $0
  1028e7:	6a 00                	push   $0x0
  pushl $226
  1028e9:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1028ee:	e9 5c 01 00 00       	jmp    102a4f <__alltraps>

001028f3 <vector227>:
.globl vector227
vector227:
  pushl $0
  1028f3:	6a 00                	push   $0x0
  pushl $227
  1028f5:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1028fa:	e9 50 01 00 00       	jmp    102a4f <__alltraps>

001028ff <vector228>:
.globl vector228
vector228:
  pushl $0
  1028ff:	6a 00                	push   $0x0
  pushl $228
  102901:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102906:	e9 44 01 00 00       	jmp    102a4f <__alltraps>

0010290b <vector229>:
.globl vector229
vector229:
  pushl $0
  10290b:	6a 00                	push   $0x0
  pushl $229
  10290d:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102912:	e9 38 01 00 00       	jmp    102a4f <__alltraps>

00102917 <vector230>:
.globl vector230
vector230:
  pushl $0
  102917:	6a 00                	push   $0x0
  pushl $230
  102919:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10291e:	e9 2c 01 00 00       	jmp    102a4f <__alltraps>

00102923 <vector231>:
.globl vector231
vector231:
  pushl $0
  102923:	6a 00                	push   $0x0
  pushl $231
  102925:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10292a:	e9 20 01 00 00       	jmp    102a4f <__alltraps>

0010292f <vector232>:
.globl vector232
vector232:
  pushl $0
  10292f:	6a 00                	push   $0x0
  pushl $232
  102931:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102936:	e9 14 01 00 00       	jmp    102a4f <__alltraps>

0010293b <vector233>:
.globl vector233
vector233:
  pushl $0
  10293b:	6a 00                	push   $0x0
  pushl $233
  10293d:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102942:	e9 08 01 00 00       	jmp    102a4f <__alltraps>

00102947 <vector234>:
.globl vector234
vector234:
  pushl $0
  102947:	6a 00                	push   $0x0
  pushl $234
  102949:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10294e:	e9 fc 00 00 00       	jmp    102a4f <__alltraps>

00102953 <vector235>:
.globl vector235
vector235:
  pushl $0
  102953:	6a 00                	push   $0x0
  pushl $235
  102955:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10295a:	e9 f0 00 00 00       	jmp    102a4f <__alltraps>

0010295f <vector236>:
.globl vector236
vector236:
  pushl $0
  10295f:	6a 00                	push   $0x0
  pushl $236
  102961:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102966:	e9 e4 00 00 00       	jmp    102a4f <__alltraps>

0010296b <vector237>:
.globl vector237
vector237:
  pushl $0
  10296b:	6a 00                	push   $0x0
  pushl $237
  10296d:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102972:	e9 d8 00 00 00       	jmp    102a4f <__alltraps>

00102977 <vector238>:
.globl vector238
vector238:
  pushl $0
  102977:	6a 00                	push   $0x0
  pushl $238
  102979:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10297e:	e9 cc 00 00 00       	jmp    102a4f <__alltraps>

00102983 <vector239>:
.globl vector239
vector239:
  pushl $0
  102983:	6a 00                	push   $0x0
  pushl $239
  102985:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10298a:	e9 c0 00 00 00       	jmp    102a4f <__alltraps>

0010298f <vector240>:
.globl vector240
vector240:
  pushl $0
  10298f:	6a 00                	push   $0x0
  pushl $240
  102991:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102996:	e9 b4 00 00 00       	jmp    102a4f <__alltraps>

0010299b <vector241>:
.globl vector241
vector241:
  pushl $0
  10299b:	6a 00                	push   $0x0
  pushl $241
  10299d:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1029a2:	e9 a8 00 00 00       	jmp    102a4f <__alltraps>

001029a7 <vector242>:
.globl vector242
vector242:
  pushl $0
  1029a7:	6a 00                	push   $0x0
  pushl $242
  1029a9:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1029ae:	e9 9c 00 00 00       	jmp    102a4f <__alltraps>

001029b3 <vector243>:
.globl vector243
vector243:
  pushl $0
  1029b3:	6a 00                	push   $0x0
  pushl $243
  1029b5:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1029ba:	e9 90 00 00 00       	jmp    102a4f <__alltraps>

001029bf <vector244>:
.globl vector244
vector244:
  pushl $0
  1029bf:	6a 00                	push   $0x0
  pushl $244
  1029c1:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1029c6:	e9 84 00 00 00       	jmp    102a4f <__alltraps>

001029cb <vector245>:
.globl vector245
vector245:
  pushl $0
  1029cb:	6a 00                	push   $0x0
  pushl $245
  1029cd:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1029d2:	e9 78 00 00 00       	jmp    102a4f <__alltraps>

001029d7 <vector246>:
.globl vector246
vector246:
  pushl $0
  1029d7:	6a 00                	push   $0x0
  pushl $246
  1029d9:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1029de:	e9 6c 00 00 00       	jmp    102a4f <__alltraps>

001029e3 <vector247>:
.globl vector247
vector247:
  pushl $0
  1029e3:	6a 00                	push   $0x0
  pushl $247
  1029e5:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1029ea:	e9 60 00 00 00       	jmp    102a4f <__alltraps>

001029ef <vector248>:
.globl vector248
vector248:
  pushl $0
  1029ef:	6a 00                	push   $0x0
  pushl $248
  1029f1:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1029f6:	e9 54 00 00 00       	jmp    102a4f <__alltraps>

001029fb <vector249>:
.globl vector249
vector249:
  pushl $0
  1029fb:	6a 00                	push   $0x0
  pushl $249
  1029fd:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102a02:	e9 48 00 00 00       	jmp    102a4f <__alltraps>

00102a07 <vector250>:
.globl vector250
vector250:
  pushl $0
  102a07:	6a 00                	push   $0x0
  pushl $250
  102a09:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102a0e:	e9 3c 00 00 00       	jmp    102a4f <__alltraps>

00102a13 <vector251>:
.globl vector251
vector251:
  pushl $0
  102a13:	6a 00                	push   $0x0
  pushl $251
  102a15:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102a1a:	e9 30 00 00 00       	jmp    102a4f <__alltraps>

00102a1f <vector252>:
.globl vector252
vector252:
  pushl $0
  102a1f:	6a 00                	push   $0x0
  pushl $252
  102a21:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102a26:	e9 24 00 00 00       	jmp    102a4f <__alltraps>

00102a2b <vector253>:
.globl vector253
vector253:
  pushl $0
  102a2b:	6a 00                	push   $0x0
  pushl $253
  102a2d:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102a32:	e9 18 00 00 00       	jmp    102a4f <__alltraps>

00102a37 <vector254>:
.globl vector254
vector254:
  pushl $0
  102a37:	6a 00                	push   $0x0
  pushl $254
  102a39:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102a3e:	e9 0c 00 00 00       	jmp    102a4f <__alltraps>

00102a43 <vector255>:
.globl vector255
vector255:
  pushl $0
  102a43:	6a 00                	push   $0x0
  pushl $255
  102a45:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102a4a:	e9 00 00 00 00       	jmp    102a4f <__alltraps>

00102a4f <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102a4f:	1e                   	push   %ds
    pushl %es
  102a50:	06                   	push   %es
    pushl %fs
  102a51:	0f a0                	push   %fs
    pushl %gs
  102a53:	0f a8                	push   %gs
    pushal
  102a55:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102a56:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102a5b:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102a5d:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102a5f:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102a60:	e8 5f f5 ff ff       	call   101fc4 <trap>

    # pop the pushed stack pointer
    popl %esp
  102a65:	5c                   	pop    %esp

00102a66 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102a66:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102a67:	0f a9                	pop    %gs
    popl %fs
  102a69:	0f a1                	pop    %fs
    popl %es
  102a6b:	07                   	pop    %es
    popl %ds
  102a6c:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102a6d:	83 c4 08             	add    $0x8,%esp
    iret
  102a70:	cf                   	iret   

00102a71 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102a71:	55                   	push   %ebp
  102a72:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102a74:	8b 45 08             	mov    0x8(%ebp),%eax
  102a77:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102a7a:	b8 23 00 00 00       	mov    $0x23,%eax
  102a7f:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102a81:	b8 23 00 00 00       	mov    $0x23,%eax
  102a86:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102a88:	b8 10 00 00 00       	mov    $0x10,%eax
  102a8d:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102a8f:	b8 10 00 00 00       	mov    $0x10,%eax
  102a94:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102a96:	b8 10 00 00 00       	mov    $0x10,%eax
  102a9b:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102a9d:	ea a4 2a 10 00 08 00 	ljmp   $0x8,$0x102aa4
}
  102aa4:	90                   	nop
  102aa5:	5d                   	pop    %ebp
  102aa6:	c3                   	ret    

00102aa7 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102aa7:	f3 0f 1e fb          	endbr32 
  102aab:	55                   	push   %ebp
  102aac:	89 e5                	mov    %esp,%ebp
  102aae:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102ab1:	b8 80 09 11 00       	mov    $0x110980,%eax
  102ab6:	05 00 04 00 00       	add    $0x400,%eax
  102abb:	a3 a4 08 11 00       	mov    %eax,0x1108a4
    ts.ts_ss0 = KERNEL_DS;
  102ac0:	66 c7 05 a8 08 11 00 	movw   $0x10,0x1108a8
  102ac7:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102ac9:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  102ad0:	68 00 
  102ad2:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102ad7:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  102add:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102ae2:	c1 e8 10             	shr    $0x10,%eax
  102ae5:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  102aea:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102af1:	83 e0 f0             	and    $0xfffffff0,%eax
  102af4:	83 c8 09             	or     $0x9,%eax
  102af7:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102afc:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102b03:	83 c8 10             	or     $0x10,%eax
  102b06:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102b0b:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102b12:	83 e0 9f             	and    $0xffffff9f,%eax
  102b15:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102b1a:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102b21:	83 c8 80             	or     $0xffffff80,%eax
  102b24:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102b29:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102b30:	83 e0 f0             	and    $0xfffffff0,%eax
  102b33:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102b38:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102b3f:	83 e0 ef             	and    $0xffffffef,%eax
  102b42:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102b47:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102b4e:	83 e0 df             	and    $0xffffffdf,%eax
  102b51:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102b56:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102b5d:	83 c8 40             	or     $0x40,%eax
  102b60:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102b65:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102b6c:	83 e0 7f             	and    $0x7f,%eax
  102b6f:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102b74:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102b79:	c1 e8 18             	shr    $0x18,%eax
  102b7c:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  102b81:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102b88:	83 e0 ef             	and    $0xffffffef,%eax
  102b8b:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102b90:	68 10 fa 10 00       	push   $0x10fa10
  102b95:	e8 d7 fe ff ff       	call   102a71 <lgdt>
  102b9a:	83 c4 04             	add    $0x4,%esp
  102b9d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102ba3:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102ba7:	0f 00 d8             	ltr    %ax
}
  102baa:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102bab:	90                   	nop
  102bac:	c9                   	leave  
  102bad:	c3                   	ret    

00102bae <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102bae:	f3 0f 1e fb          	endbr32 
  102bb2:	55                   	push   %ebp
  102bb3:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102bb5:	e8 ed fe ff ff       	call   102aa7 <gdt_init>
}
  102bba:	90                   	nop
  102bbb:	5d                   	pop    %ebp
  102bbc:	c3                   	ret    

00102bbd <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102bbd:	f3 0f 1e fb          	endbr32 
  102bc1:	55                   	push   %ebp
  102bc2:	89 e5                	mov    %esp,%ebp
  102bc4:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102bc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102bce:	eb 04                	jmp    102bd4 <strlen+0x17>
        cnt ++;
  102bd0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  102bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd7:	8d 50 01             	lea    0x1(%eax),%edx
  102bda:	89 55 08             	mov    %edx,0x8(%ebp)
  102bdd:	0f b6 00             	movzbl (%eax),%eax
  102be0:	84 c0                	test   %al,%al
  102be2:	75 ec                	jne    102bd0 <strlen+0x13>
    }
    return cnt;
  102be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102be7:	c9                   	leave  
  102be8:	c3                   	ret    

00102be9 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102be9:	f3 0f 1e fb          	endbr32 
  102bed:	55                   	push   %ebp
  102bee:	89 e5                	mov    %esp,%ebp
  102bf0:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102bf3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102bfa:	eb 04                	jmp    102c00 <strnlen+0x17>
        cnt ++;
  102bfc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c03:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102c06:	73 10                	jae    102c18 <strnlen+0x2f>
  102c08:	8b 45 08             	mov    0x8(%ebp),%eax
  102c0b:	8d 50 01             	lea    0x1(%eax),%edx
  102c0e:	89 55 08             	mov    %edx,0x8(%ebp)
  102c11:	0f b6 00             	movzbl (%eax),%eax
  102c14:	84 c0                	test   %al,%al
  102c16:	75 e4                	jne    102bfc <strnlen+0x13>
    }
    return cnt;
  102c18:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c1b:	c9                   	leave  
  102c1c:	c3                   	ret    

00102c1d <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102c1d:	f3 0f 1e fb          	endbr32 
  102c21:	55                   	push   %ebp
  102c22:	89 e5                	mov    %esp,%ebp
  102c24:	57                   	push   %edi
  102c25:	56                   	push   %esi
  102c26:	83 ec 20             	sub    $0x20,%esp
  102c29:	8b 45 08             	mov    0x8(%ebp),%eax
  102c2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c32:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102c35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c3b:	89 d1                	mov    %edx,%ecx
  102c3d:	89 c2                	mov    %eax,%edx
  102c3f:	89 ce                	mov    %ecx,%esi
  102c41:	89 d7                	mov    %edx,%edi
  102c43:	ac                   	lods   %ds:(%esi),%al
  102c44:	aa                   	stos   %al,%es:(%edi)
  102c45:	84 c0                	test   %al,%al
  102c47:	75 fa                	jne    102c43 <strcpy+0x26>
  102c49:	89 fa                	mov    %edi,%edx
  102c4b:	89 f1                	mov    %esi,%ecx
  102c4d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102c50:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102c53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102c59:	83 c4 20             	add    $0x20,%esp
  102c5c:	5e                   	pop    %esi
  102c5d:	5f                   	pop    %edi
  102c5e:	5d                   	pop    %ebp
  102c5f:	c3                   	ret    

00102c60 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102c60:	f3 0f 1e fb          	endbr32 
  102c64:	55                   	push   %ebp
  102c65:	89 e5                	mov    %esp,%ebp
  102c67:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102c70:	eb 21                	jmp    102c93 <strncpy+0x33>
        if ((*p = *src) != '\0') {
  102c72:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c75:	0f b6 10             	movzbl (%eax),%edx
  102c78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c7b:	88 10                	mov    %dl,(%eax)
  102c7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c80:	0f b6 00             	movzbl (%eax),%eax
  102c83:	84 c0                	test   %al,%al
  102c85:	74 04                	je     102c8b <strncpy+0x2b>
            src ++;
  102c87:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102c8b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102c8f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  102c93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c97:	75 d9                	jne    102c72 <strncpy+0x12>
    }
    return dst;
  102c99:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102c9c:	c9                   	leave  
  102c9d:	c3                   	ret    

00102c9e <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102c9e:	f3 0f 1e fb          	endbr32 
  102ca2:	55                   	push   %ebp
  102ca3:	89 e5                	mov    %esp,%ebp
  102ca5:	57                   	push   %edi
  102ca6:	56                   	push   %esi
  102ca7:	83 ec 20             	sub    $0x20,%esp
  102caa:	8b 45 08             	mov    0x8(%ebp),%eax
  102cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102cb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cbc:	89 d1                	mov    %edx,%ecx
  102cbe:	89 c2                	mov    %eax,%edx
  102cc0:	89 ce                	mov    %ecx,%esi
  102cc2:	89 d7                	mov    %edx,%edi
  102cc4:	ac                   	lods   %ds:(%esi),%al
  102cc5:	ae                   	scas   %es:(%edi),%al
  102cc6:	75 08                	jne    102cd0 <strcmp+0x32>
  102cc8:	84 c0                	test   %al,%al
  102cca:	75 f8                	jne    102cc4 <strcmp+0x26>
  102ccc:	31 c0                	xor    %eax,%eax
  102cce:	eb 04                	jmp    102cd4 <strcmp+0x36>
  102cd0:	19 c0                	sbb    %eax,%eax
  102cd2:	0c 01                	or     $0x1,%al
  102cd4:	89 fa                	mov    %edi,%edx
  102cd6:	89 f1                	mov    %esi,%ecx
  102cd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102cdb:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102cde:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102ce1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102ce4:	83 c4 20             	add    $0x20,%esp
  102ce7:	5e                   	pop    %esi
  102ce8:	5f                   	pop    %edi
  102ce9:	5d                   	pop    %ebp
  102cea:	c3                   	ret    

00102ceb <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102ceb:	f3 0f 1e fb          	endbr32 
  102cef:	55                   	push   %ebp
  102cf0:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102cf2:	eb 0c                	jmp    102d00 <strncmp+0x15>
        n --, s1 ++, s2 ++;
  102cf4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102cf8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102cfc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d04:	74 1a                	je     102d20 <strncmp+0x35>
  102d06:	8b 45 08             	mov    0x8(%ebp),%eax
  102d09:	0f b6 00             	movzbl (%eax),%eax
  102d0c:	84 c0                	test   %al,%al
  102d0e:	74 10                	je     102d20 <strncmp+0x35>
  102d10:	8b 45 08             	mov    0x8(%ebp),%eax
  102d13:	0f b6 10             	movzbl (%eax),%edx
  102d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d19:	0f b6 00             	movzbl (%eax),%eax
  102d1c:	38 c2                	cmp    %al,%dl
  102d1e:	74 d4                	je     102cf4 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102d20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d24:	74 18                	je     102d3e <strncmp+0x53>
  102d26:	8b 45 08             	mov    0x8(%ebp),%eax
  102d29:	0f b6 00             	movzbl (%eax),%eax
  102d2c:	0f b6 d0             	movzbl %al,%edx
  102d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d32:	0f b6 00             	movzbl (%eax),%eax
  102d35:	0f b6 c0             	movzbl %al,%eax
  102d38:	29 c2                	sub    %eax,%edx
  102d3a:	89 d0                	mov    %edx,%eax
  102d3c:	eb 05                	jmp    102d43 <strncmp+0x58>
  102d3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d43:	5d                   	pop    %ebp
  102d44:	c3                   	ret    

00102d45 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102d45:	f3 0f 1e fb          	endbr32 
  102d49:	55                   	push   %ebp
  102d4a:	89 e5                	mov    %esp,%ebp
  102d4c:	83 ec 04             	sub    $0x4,%esp
  102d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d52:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102d55:	eb 14                	jmp    102d6b <strchr+0x26>
        if (*s == c) {
  102d57:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5a:	0f b6 00             	movzbl (%eax),%eax
  102d5d:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102d60:	75 05                	jne    102d67 <strchr+0x22>
            return (char *)s;
  102d62:	8b 45 08             	mov    0x8(%ebp),%eax
  102d65:	eb 13                	jmp    102d7a <strchr+0x35>
        }
        s ++;
  102d67:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6e:	0f b6 00             	movzbl (%eax),%eax
  102d71:	84 c0                	test   %al,%al
  102d73:	75 e2                	jne    102d57 <strchr+0x12>
    }
    return NULL;
  102d75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d7a:	c9                   	leave  
  102d7b:	c3                   	ret    

00102d7c <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102d7c:	f3 0f 1e fb          	endbr32 
  102d80:	55                   	push   %ebp
  102d81:	89 e5                	mov    %esp,%ebp
  102d83:	83 ec 04             	sub    $0x4,%esp
  102d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d89:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102d8c:	eb 0f                	jmp    102d9d <strfind+0x21>
        if (*s == c) {
  102d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d91:	0f b6 00             	movzbl (%eax),%eax
  102d94:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102d97:	74 10                	je     102da9 <strfind+0x2d>
            break;
        }
        s ++;
  102d99:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  102da0:	0f b6 00             	movzbl (%eax),%eax
  102da3:	84 c0                	test   %al,%al
  102da5:	75 e7                	jne    102d8e <strfind+0x12>
  102da7:	eb 01                	jmp    102daa <strfind+0x2e>
            break;
  102da9:	90                   	nop
    }
    return (char *)s;
  102daa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102dad:	c9                   	leave  
  102dae:	c3                   	ret    

00102daf <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102daf:	f3 0f 1e fb          	endbr32 
  102db3:	55                   	push   %ebp
  102db4:	89 e5                	mov    %esp,%ebp
  102db6:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102db9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102dc0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102dc7:	eb 04                	jmp    102dcd <strtol+0x1e>
        s ++;
  102dc9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd0:	0f b6 00             	movzbl (%eax),%eax
  102dd3:	3c 20                	cmp    $0x20,%al
  102dd5:	74 f2                	je     102dc9 <strtol+0x1a>
  102dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  102dda:	0f b6 00             	movzbl (%eax),%eax
  102ddd:	3c 09                	cmp    $0x9,%al
  102ddf:	74 e8                	je     102dc9 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  102de1:	8b 45 08             	mov    0x8(%ebp),%eax
  102de4:	0f b6 00             	movzbl (%eax),%eax
  102de7:	3c 2b                	cmp    $0x2b,%al
  102de9:	75 06                	jne    102df1 <strtol+0x42>
        s ++;
  102deb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102def:	eb 15                	jmp    102e06 <strtol+0x57>
    }
    else if (*s == '-') {
  102df1:	8b 45 08             	mov    0x8(%ebp),%eax
  102df4:	0f b6 00             	movzbl (%eax),%eax
  102df7:	3c 2d                	cmp    $0x2d,%al
  102df9:	75 0b                	jne    102e06 <strtol+0x57>
        s ++, neg = 1;
  102dfb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102dff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102e06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e0a:	74 06                	je     102e12 <strtol+0x63>
  102e0c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102e10:	75 24                	jne    102e36 <strtol+0x87>
  102e12:	8b 45 08             	mov    0x8(%ebp),%eax
  102e15:	0f b6 00             	movzbl (%eax),%eax
  102e18:	3c 30                	cmp    $0x30,%al
  102e1a:	75 1a                	jne    102e36 <strtol+0x87>
  102e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1f:	83 c0 01             	add    $0x1,%eax
  102e22:	0f b6 00             	movzbl (%eax),%eax
  102e25:	3c 78                	cmp    $0x78,%al
  102e27:	75 0d                	jne    102e36 <strtol+0x87>
        s += 2, base = 16;
  102e29:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102e2d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102e34:	eb 2a                	jmp    102e60 <strtol+0xb1>
    }
    else if (base == 0 && s[0] == '0') {
  102e36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e3a:	75 17                	jne    102e53 <strtol+0xa4>
  102e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3f:	0f b6 00             	movzbl (%eax),%eax
  102e42:	3c 30                	cmp    $0x30,%al
  102e44:	75 0d                	jne    102e53 <strtol+0xa4>
        s ++, base = 8;
  102e46:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102e4a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102e51:	eb 0d                	jmp    102e60 <strtol+0xb1>
    }
    else if (base == 0) {
  102e53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e57:	75 07                	jne    102e60 <strtol+0xb1>
        base = 10;
  102e59:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102e60:	8b 45 08             	mov    0x8(%ebp),%eax
  102e63:	0f b6 00             	movzbl (%eax),%eax
  102e66:	3c 2f                	cmp    $0x2f,%al
  102e68:	7e 1b                	jle    102e85 <strtol+0xd6>
  102e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6d:	0f b6 00             	movzbl (%eax),%eax
  102e70:	3c 39                	cmp    $0x39,%al
  102e72:	7f 11                	jg     102e85 <strtol+0xd6>
            dig = *s - '0';
  102e74:	8b 45 08             	mov    0x8(%ebp),%eax
  102e77:	0f b6 00             	movzbl (%eax),%eax
  102e7a:	0f be c0             	movsbl %al,%eax
  102e7d:	83 e8 30             	sub    $0x30,%eax
  102e80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e83:	eb 48                	jmp    102ecd <strtol+0x11e>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102e85:	8b 45 08             	mov    0x8(%ebp),%eax
  102e88:	0f b6 00             	movzbl (%eax),%eax
  102e8b:	3c 60                	cmp    $0x60,%al
  102e8d:	7e 1b                	jle    102eaa <strtol+0xfb>
  102e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e92:	0f b6 00             	movzbl (%eax),%eax
  102e95:	3c 7a                	cmp    $0x7a,%al
  102e97:	7f 11                	jg     102eaa <strtol+0xfb>
            dig = *s - 'a' + 10;
  102e99:	8b 45 08             	mov    0x8(%ebp),%eax
  102e9c:	0f b6 00             	movzbl (%eax),%eax
  102e9f:	0f be c0             	movsbl %al,%eax
  102ea2:	83 e8 57             	sub    $0x57,%eax
  102ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ea8:	eb 23                	jmp    102ecd <strtol+0x11e>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  102ead:	0f b6 00             	movzbl (%eax),%eax
  102eb0:	3c 40                	cmp    $0x40,%al
  102eb2:	7e 3c                	jle    102ef0 <strtol+0x141>
  102eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb7:	0f b6 00             	movzbl (%eax),%eax
  102eba:	3c 5a                	cmp    $0x5a,%al
  102ebc:	7f 32                	jg     102ef0 <strtol+0x141>
            dig = *s - 'A' + 10;
  102ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec1:	0f b6 00             	movzbl (%eax),%eax
  102ec4:	0f be c0             	movsbl %al,%eax
  102ec7:	83 e8 37             	sub    $0x37,%eax
  102eca:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ed0:	3b 45 10             	cmp    0x10(%ebp),%eax
  102ed3:	7d 1a                	jge    102eef <strtol+0x140>
            break;
        }
        s ++, val = (val * base) + dig;
  102ed5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102ed9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102edc:	0f af 45 10          	imul   0x10(%ebp),%eax
  102ee0:	89 c2                	mov    %eax,%edx
  102ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ee5:	01 d0                	add    %edx,%eax
  102ee7:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102eea:	e9 71 ff ff ff       	jmp    102e60 <strtol+0xb1>
            break;
  102eef:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102ef0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102ef4:	74 08                	je     102efe <strtol+0x14f>
        *endptr = (char *) s;
  102ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  102efc:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102efe:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102f02:	74 07                	je     102f0b <strtol+0x15c>
  102f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f07:	f7 d8                	neg    %eax
  102f09:	eb 03                	jmp    102f0e <strtol+0x15f>
  102f0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102f0e:	c9                   	leave  
  102f0f:	c3                   	ret    

00102f10 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102f10:	f3 0f 1e fb          	endbr32 
  102f14:	55                   	push   %ebp
  102f15:	89 e5                	mov    %esp,%ebp
  102f17:	57                   	push   %edi
  102f18:	83 ec 24             	sub    $0x24,%esp
  102f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f1e:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102f21:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102f25:	8b 55 08             	mov    0x8(%ebp),%edx
  102f28:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102f2b:	88 45 f7             	mov    %al,-0x9(%ebp)
  102f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  102f31:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102f34:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102f37:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102f3b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102f3e:	89 d7                	mov    %edx,%edi
  102f40:	f3 aa                	rep stos %al,%es:(%edi)
  102f42:	89 fa                	mov    %edi,%edx
  102f44:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102f47:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102f4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102f4d:	83 c4 24             	add    $0x24,%esp
  102f50:	5f                   	pop    %edi
  102f51:	5d                   	pop    %ebp
  102f52:	c3                   	ret    

00102f53 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102f53:	f3 0f 1e fb          	endbr32 
  102f57:	55                   	push   %ebp
  102f58:	89 e5                	mov    %esp,%ebp
  102f5a:	57                   	push   %edi
  102f5b:	56                   	push   %esi
  102f5c:	53                   	push   %ebx
  102f5d:	83 ec 30             	sub    $0x30,%esp
  102f60:	8b 45 08             	mov    0x8(%ebp),%eax
  102f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f69:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f6c:	8b 45 10             	mov    0x10(%ebp),%eax
  102f6f:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f75:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102f78:	73 42                	jae    102fbc <memmove+0x69>
  102f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f83:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f89:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102f8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f8f:	c1 e8 02             	shr    $0x2,%eax
  102f92:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102f94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102f97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f9a:	89 d7                	mov    %edx,%edi
  102f9c:	89 c6                	mov    %eax,%esi
  102f9e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102fa0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102fa3:	83 e1 03             	and    $0x3,%ecx
  102fa6:	74 02                	je     102faa <memmove+0x57>
  102fa8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102faa:	89 f0                	mov    %esi,%eax
  102fac:	89 fa                	mov    %edi,%edx
  102fae:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102fb1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102fb4:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102fb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  102fba:	eb 36                	jmp    102ff2 <memmove+0x9f>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102fbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  102fc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fc5:	01 c2                	add    %eax,%edx
  102fc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fca:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fd0:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102fd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fd6:	89 c1                	mov    %eax,%ecx
  102fd8:	89 d8                	mov    %ebx,%eax
  102fda:	89 d6                	mov    %edx,%esi
  102fdc:	89 c7                	mov    %eax,%edi
  102fde:	fd                   	std    
  102fdf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102fe1:	fc                   	cld    
  102fe2:	89 f8                	mov    %edi,%eax
  102fe4:	89 f2                	mov    %esi,%edx
  102fe6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102fe9:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102fec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102ff2:	83 c4 30             	add    $0x30,%esp
  102ff5:	5b                   	pop    %ebx
  102ff6:	5e                   	pop    %esi
  102ff7:	5f                   	pop    %edi
  102ff8:	5d                   	pop    %ebp
  102ff9:	c3                   	ret    

00102ffa <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102ffa:	f3 0f 1e fb          	endbr32 
  102ffe:	55                   	push   %ebp
  102fff:	89 e5                	mov    %esp,%ebp
  103001:	57                   	push   %edi
  103002:	56                   	push   %esi
  103003:	83 ec 20             	sub    $0x20,%esp
  103006:	8b 45 08             	mov    0x8(%ebp),%eax
  103009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10300c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10300f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103012:	8b 45 10             	mov    0x10(%ebp),%eax
  103015:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103018:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10301b:	c1 e8 02             	shr    $0x2,%eax
  10301e:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103020:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103023:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103026:	89 d7                	mov    %edx,%edi
  103028:	89 c6                	mov    %eax,%esi
  10302a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10302c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10302f:	83 e1 03             	and    $0x3,%ecx
  103032:	74 02                	je     103036 <memcpy+0x3c>
  103034:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103036:	89 f0                	mov    %esi,%eax
  103038:	89 fa                	mov    %edi,%edx
  10303a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10303d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103040:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  103043:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103046:	83 c4 20             	add    $0x20,%esp
  103049:	5e                   	pop    %esi
  10304a:	5f                   	pop    %edi
  10304b:	5d                   	pop    %ebp
  10304c:	c3                   	ret    

0010304d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10304d:	f3 0f 1e fb          	endbr32 
  103051:	55                   	push   %ebp
  103052:	89 e5                	mov    %esp,%ebp
  103054:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103057:	8b 45 08             	mov    0x8(%ebp),%eax
  10305a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10305d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103060:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103063:	eb 30                	jmp    103095 <memcmp+0x48>
        if (*s1 != *s2) {
  103065:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103068:	0f b6 10             	movzbl (%eax),%edx
  10306b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10306e:	0f b6 00             	movzbl (%eax),%eax
  103071:	38 c2                	cmp    %al,%dl
  103073:	74 18                	je     10308d <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103075:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103078:	0f b6 00             	movzbl (%eax),%eax
  10307b:	0f b6 d0             	movzbl %al,%edx
  10307e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103081:	0f b6 00             	movzbl (%eax),%eax
  103084:	0f b6 c0             	movzbl %al,%eax
  103087:	29 c2                	sub    %eax,%edx
  103089:	89 d0                	mov    %edx,%eax
  10308b:	eb 1a                	jmp    1030a7 <memcmp+0x5a>
        }
        s1 ++, s2 ++;
  10308d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103091:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  103095:	8b 45 10             	mov    0x10(%ebp),%eax
  103098:	8d 50 ff             	lea    -0x1(%eax),%edx
  10309b:	89 55 10             	mov    %edx,0x10(%ebp)
  10309e:	85 c0                	test   %eax,%eax
  1030a0:	75 c3                	jne    103065 <memcmp+0x18>
    }
    return 0;
  1030a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1030a7:	c9                   	leave  
  1030a8:	c3                   	ret    

001030a9 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1030a9:	f3 0f 1e fb          	endbr32 
  1030ad:	55                   	push   %ebp
  1030ae:	89 e5                	mov    %esp,%ebp
  1030b0:	83 ec 38             	sub    $0x38,%esp
  1030b3:	8b 45 10             	mov    0x10(%ebp),%eax
  1030b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030b9:	8b 45 14             	mov    0x14(%ebp),%eax
  1030bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1030bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030c2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1030c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1030c8:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1030cb:	8b 45 18             	mov    0x18(%ebp),%eax
  1030ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1030d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1030d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1030da:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1030dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1030e7:	74 1c                	je     103105 <printnum+0x5c>
  1030e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030ec:	ba 00 00 00 00       	mov    $0x0,%edx
  1030f1:	f7 75 e4             	divl   -0x1c(%ebp)
  1030f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1030f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030fa:	ba 00 00 00 00       	mov    $0x0,%edx
  1030ff:	f7 75 e4             	divl   -0x1c(%ebp)
  103102:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103105:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10310b:	f7 75 e4             	divl   -0x1c(%ebp)
  10310e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103111:	89 55 dc             	mov    %edx,-0x24(%ebp)
  103114:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103117:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10311a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10311d:	89 55 ec             	mov    %edx,-0x14(%ebp)
  103120:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103123:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  103126:	8b 45 18             	mov    0x18(%ebp),%eax
  103129:	ba 00 00 00 00       	mov    $0x0,%edx
  10312e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  103131:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103134:	19 d1                	sbb    %edx,%ecx
  103136:	72 37                	jb     10316f <printnum+0xc6>
        printnum(putch, putdat, result, base, width - 1, padc);
  103138:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10313b:	83 e8 01             	sub    $0x1,%eax
  10313e:	83 ec 04             	sub    $0x4,%esp
  103141:	ff 75 20             	pushl  0x20(%ebp)
  103144:	50                   	push   %eax
  103145:	ff 75 18             	pushl  0x18(%ebp)
  103148:	ff 75 ec             	pushl  -0x14(%ebp)
  10314b:	ff 75 e8             	pushl  -0x18(%ebp)
  10314e:	ff 75 0c             	pushl  0xc(%ebp)
  103151:	ff 75 08             	pushl  0x8(%ebp)
  103154:	e8 50 ff ff ff       	call   1030a9 <printnum>
  103159:	83 c4 20             	add    $0x20,%esp
  10315c:	eb 1b                	jmp    103179 <printnum+0xd0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10315e:	83 ec 08             	sub    $0x8,%esp
  103161:	ff 75 0c             	pushl  0xc(%ebp)
  103164:	ff 75 20             	pushl  0x20(%ebp)
  103167:	8b 45 08             	mov    0x8(%ebp),%eax
  10316a:	ff d0                	call   *%eax
  10316c:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  10316f:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  103173:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103177:	7f e5                	jg     10315e <printnum+0xb5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  103179:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10317c:	05 70 3e 10 00       	add    $0x103e70,%eax
  103181:	0f b6 00             	movzbl (%eax),%eax
  103184:	0f be c0             	movsbl %al,%eax
  103187:	83 ec 08             	sub    $0x8,%esp
  10318a:	ff 75 0c             	pushl  0xc(%ebp)
  10318d:	50                   	push   %eax
  10318e:	8b 45 08             	mov    0x8(%ebp),%eax
  103191:	ff d0                	call   *%eax
  103193:	83 c4 10             	add    $0x10,%esp
}
  103196:	90                   	nop
  103197:	c9                   	leave  
  103198:	c3                   	ret    

00103199 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  103199:	f3 0f 1e fb          	endbr32 
  10319d:	55                   	push   %ebp
  10319e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1031a0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1031a4:	7e 14                	jle    1031ba <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  1031a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a9:	8b 00                	mov    (%eax),%eax
  1031ab:	8d 48 08             	lea    0x8(%eax),%ecx
  1031ae:	8b 55 08             	mov    0x8(%ebp),%edx
  1031b1:	89 0a                	mov    %ecx,(%edx)
  1031b3:	8b 50 04             	mov    0x4(%eax),%edx
  1031b6:	8b 00                	mov    (%eax),%eax
  1031b8:	eb 30                	jmp    1031ea <getuint+0x51>
    }
    else if (lflag) {
  1031ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1031be:	74 16                	je     1031d6 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  1031c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1031c3:	8b 00                	mov    (%eax),%eax
  1031c5:	8d 48 04             	lea    0x4(%eax),%ecx
  1031c8:	8b 55 08             	mov    0x8(%ebp),%edx
  1031cb:	89 0a                	mov    %ecx,(%edx)
  1031cd:	8b 00                	mov    (%eax),%eax
  1031cf:	ba 00 00 00 00       	mov    $0x0,%edx
  1031d4:	eb 14                	jmp    1031ea <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  1031d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d9:	8b 00                	mov    (%eax),%eax
  1031db:	8d 48 04             	lea    0x4(%eax),%ecx
  1031de:	8b 55 08             	mov    0x8(%ebp),%edx
  1031e1:	89 0a                	mov    %ecx,(%edx)
  1031e3:	8b 00                	mov    (%eax),%eax
  1031e5:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1031ea:	5d                   	pop    %ebp
  1031eb:	c3                   	ret    

001031ec <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1031ec:	f3 0f 1e fb          	endbr32 
  1031f0:	55                   	push   %ebp
  1031f1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1031f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1031f7:	7e 14                	jle    10320d <getint+0x21>
        return va_arg(*ap, long long);
  1031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fc:	8b 00                	mov    (%eax),%eax
  1031fe:	8d 48 08             	lea    0x8(%eax),%ecx
  103201:	8b 55 08             	mov    0x8(%ebp),%edx
  103204:	89 0a                	mov    %ecx,(%edx)
  103206:	8b 50 04             	mov    0x4(%eax),%edx
  103209:	8b 00                	mov    (%eax),%eax
  10320b:	eb 28                	jmp    103235 <getint+0x49>
    }
    else if (lflag) {
  10320d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103211:	74 12                	je     103225 <getint+0x39>
        return va_arg(*ap, long);
  103213:	8b 45 08             	mov    0x8(%ebp),%eax
  103216:	8b 00                	mov    (%eax),%eax
  103218:	8d 48 04             	lea    0x4(%eax),%ecx
  10321b:	8b 55 08             	mov    0x8(%ebp),%edx
  10321e:	89 0a                	mov    %ecx,(%edx)
  103220:	8b 00                	mov    (%eax),%eax
  103222:	99                   	cltd   
  103223:	eb 10                	jmp    103235 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  103225:	8b 45 08             	mov    0x8(%ebp),%eax
  103228:	8b 00                	mov    (%eax),%eax
  10322a:	8d 48 04             	lea    0x4(%eax),%ecx
  10322d:	8b 55 08             	mov    0x8(%ebp),%edx
  103230:	89 0a                	mov    %ecx,(%edx)
  103232:	8b 00                	mov    (%eax),%eax
  103234:	99                   	cltd   
    }
}
  103235:	5d                   	pop    %ebp
  103236:	c3                   	ret    

00103237 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  103237:	f3 0f 1e fb          	endbr32 
  10323b:	55                   	push   %ebp
  10323c:	89 e5                	mov    %esp,%ebp
  10323e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  103241:	8d 45 14             	lea    0x14(%ebp),%eax
  103244:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  103247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10324a:	50                   	push   %eax
  10324b:	ff 75 10             	pushl  0x10(%ebp)
  10324e:	ff 75 0c             	pushl  0xc(%ebp)
  103251:	ff 75 08             	pushl  0x8(%ebp)
  103254:	e8 06 00 00 00       	call   10325f <vprintfmt>
  103259:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  10325c:	90                   	nop
  10325d:	c9                   	leave  
  10325e:	c3                   	ret    

0010325f <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10325f:	f3 0f 1e fb          	endbr32 
  103263:	55                   	push   %ebp
  103264:	89 e5                	mov    %esp,%ebp
  103266:	56                   	push   %esi
  103267:	53                   	push   %ebx
  103268:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10326b:	eb 17                	jmp    103284 <vprintfmt+0x25>
            if (ch == '\0') {
  10326d:	85 db                	test   %ebx,%ebx
  10326f:	0f 84 8f 03 00 00    	je     103604 <vprintfmt+0x3a5>
                return;
            }
            putch(ch, putdat);
  103275:	83 ec 08             	sub    $0x8,%esp
  103278:	ff 75 0c             	pushl  0xc(%ebp)
  10327b:	53                   	push   %ebx
  10327c:	8b 45 08             	mov    0x8(%ebp),%eax
  10327f:	ff d0                	call   *%eax
  103281:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103284:	8b 45 10             	mov    0x10(%ebp),%eax
  103287:	8d 50 01             	lea    0x1(%eax),%edx
  10328a:	89 55 10             	mov    %edx,0x10(%ebp)
  10328d:	0f b6 00             	movzbl (%eax),%eax
  103290:	0f b6 d8             	movzbl %al,%ebx
  103293:	83 fb 25             	cmp    $0x25,%ebx
  103296:	75 d5                	jne    10326d <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  103298:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10329c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1032a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1032a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1032b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1032b3:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1032b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1032b9:	8d 50 01             	lea    0x1(%eax),%edx
  1032bc:	89 55 10             	mov    %edx,0x10(%ebp)
  1032bf:	0f b6 00             	movzbl (%eax),%eax
  1032c2:	0f b6 d8             	movzbl %al,%ebx
  1032c5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1032c8:	83 f8 55             	cmp    $0x55,%eax
  1032cb:	0f 87 06 03 00 00    	ja     1035d7 <vprintfmt+0x378>
  1032d1:	8b 04 85 94 3e 10 00 	mov    0x103e94(,%eax,4),%eax
  1032d8:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1032db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1032df:	eb d5                	jmp    1032b6 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1032e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1032e5:	eb cf                	jmp    1032b6 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1032e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1032ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1032f1:	89 d0                	mov    %edx,%eax
  1032f3:	c1 e0 02             	shl    $0x2,%eax
  1032f6:	01 d0                	add    %edx,%eax
  1032f8:	01 c0                	add    %eax,%eax
  1032fa:	01 d8                	add    %ebx,%eax
  1032fc:	83 e8 30             	sub    $0x30,%eax
  1032ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  103302:	8b 45 10             	mov    0x10(%ebp),%eax
  103305:	0f b6 00             	movzbl (%eax),%eax
  103308:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10330b:	83 fb 2f             	cmp    $0x2f,%ebx
  10330e:	7e 39                	jle    103349 <vprintfmt+0xea>
  103310:	83 fb 39             	cmp    $0x39,%ebx
  103313:	7f 34                	jg     103349 <vprintfmt+0xea>
            for (precision = 0; ; ++ fmt) {
  103315:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
  103319:	eb d3                	jmp    1032ee <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  10331b:	8b 45 14             	mov    0x14(%ebp),%eax
  10331e:	8d 50 04             	lea    0x4(%eax),%edx
  103321:	89 55 14             	mov    %edx,0x14(%ebp)
  103324:	8b 00                	mov    (%eax),%eax
  103326:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  103329:	eb 1f                	jmp    10334a <vprintfmt+0xeb>

        case '.':
            if (width < 0)
  10332b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10332f:	79 85                	jns    1032b6 <vprintfmt+0x57>
                width = 0;
  103331:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  103338:	e9 79 ff ff ff       	jmp    1032b6 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  10333d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  103344:	e9 6d ff ff ff       	jmp    1032b6 <vprintfmt+0x57>
            goto process_precision;
  103349:	90                   	nop

        process_precision:
            if (width < 0)
  10334a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10334e:	0f 89 62 ff ff ff    	jns    1032b6 <vprintfmt+0x57>
                width = precision, precision = -1;
  103354:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103357:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10335a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  103361:	e9 50 ff ff ff       	jmp    1032b6 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  103366:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  10336a:	e9 47 ff ff ff       	jmp    1032b6 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10336f:	8b 45 14             	mov    0x14(%ebp),%eax
  103372:	8d 50 04             	lea    0x4(%eax),%edx
  103375:	89 55 14             	mov    %edx,0x14(%ebp)
  103378:	8b 00                	mov    (%eax),%eax
  10337a:	83 ec 08             	sub    $0x8,%esp
  10337d:	ff 75 0c             	pushl  0xc(%ebp)
  103380:	50                   	push   %eax
  103381:	8b 45 08             	mov    0x8(%ebp),%eax
  103384:	ff d0                	call   *%eax
  103386:	83 c4 10             	add    $0x10,%esp
            break;
  103389:	e9 71 02 00 00       	jmp    1035ff <vprintfmt+0x3a0>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10338e:	8b 45 14             	mov    0x14(%ebp),%eax
  103391:	8d 50 04             	lea    0x4(%eax),%edx
  103394:	89 55 14             	mov    %edx,0x14(%ebp)
  103397:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  103399:	85 db                	test   %ebx,%ebx
  10339b:	79 02                	jns    10339f <vprintfmt+0x140>
                err = -err;
  10339d:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10339f:	83 fb 06             	cmp    $0x6,%ebx
  1033a2:	7f 0b                	jg     1033af <vprintfmt+0x150>
  1033a4:	8b 34 9d 54 3e 10 00 	mov    0x103e54(,%ebx,4),%esi
  1033ab:	85 f6                	test   %esi,%esi
  1033ad:	75 19                	jne    1033c8 <vprintfmt+0x169>
                printfmt(putch, putdat, "error %d", err);
  1033af:	53                   	push   %ebx
  1033b0:	68 81 3e 10 00       	push   $0x103e81
  1033b5:	ff 75 0c             	pushl  0xc(%ebp)
  1033b8:	ff 75 08             	pushl  0x8(%ebp)
  1033bb:	e8 77 fe ff ff       	call   103237 <printfmt>
  1033c0:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1033c3:	e9 37 02 00 00       	jmp    1035ff <vprintfmt+0x3a0>
                printfmt(putch, putdat, "%s", p);
  1033c8:	56                   	push   %esi
  1033c9:	68 8a 3e 10 00       	push   $0x103e8a
  1033ce:	ff 75 0c             	pushl  0xc(%ebp)
  1033d1:	ff 75 08             	pushl  0x8(%ebp)
  1033d4:	e8 5e fe ff ff       	call   103237 <printfmt>
  1033d9:	83 c4 10             	add    $0x10,%esp
            break;
  1033dc:	e9 1e 02 00 00       	jmp    1035ff <vprintfmt+0x3a0>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1033e1:	8b 45 14             	mov    0x14(%ebp),%eax
  1033e4:	8d 50 04             	lea    0x4(%eax),%edx
  1033e7:	89 55 14             	mov    %edx,0x14(%ebp)
  1033ea:	8b 30                	mov    (%eax),%esi
  1033ec:	85 f6                	test   %esi,%esi
  1033ee:	75 05                	jne    1033f5 <vprintfmt+0x196>
                p = "(null)";
  1033f0:	be 8d 3e 10 00       	mov    $0x103e8d,%esi
            }
            if (width > 0 && padc != '-') {
  1033f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033f9:	7e 76                	jle    103471 <vprintfmt+0x212>
  1033fb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1033ff:	74 70                	je     103471 <vprintfmt+0x212>
                for (width -= strnlen(p, precision); width > 0; width --) {
  103401:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103404:	83 ec 08             	sub    $0x8,%esp
  103407:	50                   	push   %eax
  103408:	56                   	push   %esi
  103409:	e8 db f7 ff ff       	call   102be9 <strnlen>
  10340e:	83 c4 10             	add    $0x10,%esp
  103411:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103414:	29 c2                	sub    %eax,%edx
  103416:	89 d0                	mov    %edx,%eax
  103418:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10341b:	eb 17                	jmp    103434 <vprintfmt+0x1d5>
                    putch(padc, putdat);
  10341d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  103421:	83 ec 08             	sub    $0x8,%esp
  103424:	ff 75 0c             	pushl  0xc(%ebp)
  103427:	50                   	push   %eax
  103428:	8b 45 08             	mov    0x8(%ebp),%eax
  10342b:	ff d0                	call   *%eax
  10342d:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  103430:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103434:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103438:	7f e3                	jg     10341d <vprintfmt+0x1be>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10343a:	eb 35                	jmp    103471 <vprintfmt+0x212>
                if (altflag && (ch < ' ' || ch > '~')) {
  10343c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103440:	74 1c                	je     10345e <vprintfmt+0x1ff>
  103442:	83 fb 1f             	cmp    $0x1f,%ebx
  103445:	7e 05                	jle    10344c <vprintfmt+0x1ed>
  103447:	83 fb 7e             	cmp    $0x7e,%ebx
  10344a:	7e 12                	jle    10345e <vprintfmt+0x1ff>
                    putch('?', putdat);
  10344c:	83 ec 08             	sub    $0x8,%esp
  10344f:	ff 75 0c             	pushl  0xc(%ebp)
  103452:	6a 3f                	push   $0x3f
  103454:	8b 45 08             	mov    0x8(%ebp),%eax
  103457:	ff d0                	call   *%eax
  103459:	83 c4 10             	add    $0x10,%esp
  10345c:	eb 0f                	jmp    10346d <vprintfmt+0x20e>
                }
                else {
                    putch(ch, putdat);
  10345e:	83 ec 08             	sub    $0x8,%esp
  103461:	ff 75 0c             	pushl  0xc(%ebp)
  103464:	53                   	push   %ebx
  103465:	8b 45 08             	mov    0x8(%ebp),%eax
  103468:	ff d0                	call   *%eax
  10346a:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10346d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103471:	89 f0                	mov    %esi,%eax
  103473:	8d 70 01             	lea    0x1(%eax),%esi
  103476:	0f b6 00             	movzbl (%eax),%eax
  103479:	0f be d8             	movsbl %al,%ebx
  10347c:	85 db                	test   %ebx,%ebx
  10347e:	74 26                	je     1034a6 <vprintfmt+0x247>
  103480:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103484:	78 b6                	js     10343c <vprintfmt+0x1dd>
  103486:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  10348a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10348e:	79 ac                	jns    10343c <vprintfmt+0x1dd>
                }
            }
            for (; width > 0; width --) {
  103490:	eb 14                	jmp    1034a6 <vprintfmt+0x247>
                putch(' ', putdat);
  103492:	83 ec 08             	sub    $0x8,%esp
  103495:	ff 75 0c             	pushl  0xc(%ebp)
  103498:	6a 20                	push   $0x20
  10349a:	8b 45 08             	mov    0x8(%ebp),%eax
  10349d:	ff d0                	call   *%eax
  10349f:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  1034a2:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1034a6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1034aa:	7f e6                	jg     103492 <vprintfmt+0x233>
            }
            break;
  1034ac:	e9 4e 01 00 00       	jmp    1035ff <vprintfmt+0x3a0>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1034b1:	83 ec 08             	sub    $0x8,%esp
  1034b4:	ff 75 e0             	pushl  -0x20(%ebp)
  1034b7:	8d 45 14             	lea    0x14(%ebp),%eax
  1034ba:	50                   	push   %eax
  1034bb:	e8 2c fd ff ff       	call   1031ec <getint>
  1034c0:	83 c4 10             	add    $0x10,%esp
  1034c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1034c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1034cf:	85 d2                	test   %edx,%edx
  1034d1:	79 23                	jns    1034f6 <vprintfmt+0x297>
                putch('-', putdat);
  1034d3:	83 ec 08             	sub    $0x8,%esp
  1034d6:	ff 75 0c             	pushl  0xc(%ebp)
  1034d9:	6a 2d                	push   $0x2d
  1034db:	8b 45 08             	mov    0x8(%ebp),%eax
  1034de:	ff d0                	call   *%eax
  1034e0:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  1034e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1034e9:	f7 d8                	neg    %eax
  1034eb:	83 d2 00             	adc    $0x0,%edx
  1034ee:	f7 da                	neg    %edx
  1034f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1034f6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1034fd:	e9 9f 00 00 00       	jmp    1035a1 <vprintfmt+0x342>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103502:	83 ec 08             	sub    $0x8,%esp
  103505:	ff 75 e0             	pushl  -0x20(%ebp)
  103508:	8d 45 14             	lea    0x14(%ebp),%eax
  10350b:	50                   	push   %eax
  10350c:	e8 88 fc ff ff       	call   103199 <getuint>
  103511:	83 c4 10             	add    $0x10,%esp
  103514:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103517:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10351a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103521:	eb 7e                	jmp    1035a1 <vprintfmt+0x342>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103523:	83 ec 08             	sub    $0x8,%esp
  103526:	ff 75 e0             	pushl  -0x20(%ebp)
  103529:	8d 45 14             	lea    0x14(%ebp),%eax
  10352c:	50                   	push   %eax
  10352d:	e8 67 fc ff ff       	call   103199 <getuint>
  103532:	83 c4 10             	add    $0x10,%esp
  103535:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103538:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10353b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103542:	eb 5d                	jmp    1035a1 <vprintfmt+0x342>

        // pointer
        case 'p':
            putch('0', putdat);
  103544:	83 ec 08             	sub    $0x8,%esp
  103547:	ff 75 0c             	pushl  0xc(%ebp)
  10354a:	6a 30                	push   $0x30
  10354c:	8b 45 08             	mov    0x8(%ebp),%eax
  10354f:	ff d0                	call   *%eax
  103551:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  103554:	83 ec 08             	sub    $0x8,%esp
  103557:	ff 75 0c             	pushl  0xc(%ebp)
  10355a:	6a 78                	push   $0x78
  10355c:	8b 45 08             	mov    0x8(%ebp),%eax
  10355f:	ff d0                	call   *%eax
  103561:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  103564:	8b 45 14             	mov    0x14(%ebp),%eax
  103567:	8d 50 04             	lea    0x4(%eax),%edx
  10356a:	89 55 14             	mov    %edx,0x14(%ebp)
  10356d:	8b 00                	mov    (%eax),%eax
  10356f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103572:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103579:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103580:	eb 1f                	jmp    1035a1 <vprintfmt+0x342>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103582:	83 ec 08             	sub    $0x8,%esp
  103585:	ff 75 e0             	pushl  -0x20(%ebp)
  103588:	8d 45 14             	lea    0x14(%ebp),%eax
  10358b:	50                   	push   %eax
  10358c:	e8 08 fc ff ff       	call   103199 <getuint>
  103591:	83 c4 10             	add    $0x10,%esp
  103594:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103597:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10359a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1035a1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1035a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035a8:	83 ec 04             	sub    $0x4,%esp
  1035ab:	52                   	push   %edx
  1035ac:	ff 75 e8             	pushl  -0x18(%ebp)
  1035af:	50                   	push   %eax
  1035b0:	ff 75 f4             	pushl  -0xc(%ebp)
  1035b3:	ff 75 f0             	pushl  -0x10(%ebp)
  1035b6:	ff 75 0c             	pushl  0xc(%ebp)
  1035b9:	ff 75 08             	pushl  0x8(%ebp)
  1035bc:	e8 e8 fa ff ff       	call   1030a9 <printnum>
  1035c1:	83 c4 20             	add    $0x20,%esp
            break;
  1035c4:	eb 39                	jmp    1035ff <vprintfmt+0x3a0>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1035c6:	83 ec 08             	sub    $0x8,%esp
  1035c9:	ff 75 0c             	pushl  0xc(%ebp)
  1035cc:	53                   	push   %ebx
  1035cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1035d0:	ff d0                	call   *%eax
  1035d2:	83 c4 10             	add    $0x10,%esp
            break;
  1035d5:	eb 28                	jmp    1035ff <vprintfmt+0x3a0>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1035d7:	83 ec 08             	sub    $0x8,%esp
  1035da:	ff 75 0c             	pushl  0xc(%ebp)
  1035dd:	6a 25                	push   $0x25
  1035df:	8b 45 08             	mov    0x8(%ebp),%eax
  1035e2:	ff d0                	call   *%eax
  1035e4:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  1035e7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1035eb:	eb 04                	jmp    1035f1 <vprintfmt+0x392>
  1035ed:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1035f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1035f4:	83 e8 01             	sub    $0x1,%eax
  1035f7:	0f b6 00             	movzbl (%eax),%eax
  1035fa:	3c 25                	cmp    $0x25,%al
  1035fc:	75 ef                	jne    1035ed <vprintfmt+0x38e>
                /* do nothing */;
            break;
  1035fe:	90                   	nop
    while (1) {
  1035ff:	e9 67 fc ff ff       	jmp    10326b <vprintfmt+0xc>
                return;
  103604:	90                   	nop
        }
    }
}
  103605:	8d 65 f8             	lea    -0x8(%ebp),%esp
  103608:	5b                   	pop    %ebx
  103609:	5e                   	pop    %esi
  10360a:	5d                   	pop    %ebp
  10360b:	c3                   	ret    

0010360c <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10360c:	f3 0f 1e fb          	endbr32 
  103610:	55                   	push   %ebp
  103611:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103613:	8b 45 0c             	mov    0xc(%ebp),%eax
  103616:	8b 40 08             	mov    0x8(%eax),%eax
  103619:	8d 50 01             	lea    0x1(%eax),%edx
  10361c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10361f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103622:	8b 45 0c             	mov    0xc(%ebp),%eax
  103625:	8b 10                	mov    (%eax),%edx
  103627:	8b 45 0c             	mov    0xc(%ebp),%eax
  10362a:	8b 40 04             	mov    0x4(%eax),%eax
  10362d:	39 c2                	cmp    %eax,%edx
  10362f:	73 12                	jae    103643 <sprintputch+0x37>
        *b->buf ++ = ch;
  103631:	8b 45 0c             	mov    0xc(%ebp),%eax
  103634:	8b 00                	mov    (%eax),%eax
  103636:	8d 48 01             	lea    0x1(%eax),%ecx
  103639:	8b 55 0c             	mov    0xc(%ebp),%edx
  10363c:	89 0a                	mov    %ecx,(%edx)
  10363e:	8b 55 08             	mov    0x8(%ebp),%edx
  103641:	88 10                	mov    %dl,(%eax)
    }
}
  103643:	90                   	nop
  103644:	5d                   	pop    %ebp
  103645:	c3                   	ret    

00103646 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103646:	f3 0f 1e fb          	endbr32 
  10364a:	55                   	push   %ebp
  10364b:	89 e5                	mov    %esp,%ebp
  10364d:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103650:	8d 45 14             	lea    0x14(%ebp),%eax
  103653:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103659:	50                   	push   %eax
  10365a:	ff 75 10             	pushl  0x10(%ebp)
  10365d:	ff 75 0c             	pushl  0xc(%ebp)
  103660:	ff 75 08             	pushl  0x8(%ebp)
  103663:	e8 0b 00 00 00       	call   103673 <vsnprintf>
  103668:	83 c4 10             	add    $0x10,%esp
  10366b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10366e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103671:	c9                   	leave  
  103672:	c3                   	ret    

00103673 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103673:	f3 0f 1e fb          	endbr32 
  103677:	55                   	push   %ebp
  103678:	89 e5                	mov    %esp,%ebp
  10367a:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10367d:	8b 45 08             	mov    0x8(%ebp),%eax
  103680:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103683:	8b 45 0c             	mov    0xc(%ebp),%eax
  103686:	8d 50 ff             	lea    -0x1(%eax),%edx
  103689:	8b 45 08             	mov    0x8(%ebp),%eax
  10368c:	01 d0                	add    %edx,%eax
  10368e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103691:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103698:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10369c:	74 0a                	je     1036a8 <vsnprintf+0x35>
  10369e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1036a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036a4:	39 c2                	cmp    %eax,%edx
  1036a6:	76 07                	jbe    1036af <vsnprintf+0x3c>
        return -E_INVAL;
  1036a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1036ad:	eb 20                	jmp    1036cf <vsnprintf+0x5c>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1036af:	ff 75 14             	pushl  0x14(%ebp)
  1036b2:	ff 75 10             	pushl  0x10(%ebp)
  1036b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1036b8:	50                   	push   %eax
  1036b9:	68 0c 36 10 00       	push   $0x10360c
  1036be:	e8 9c fb ff ff       	call   10325f <vprintfmt>
  1036c3:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  1036c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036c9:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1036cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1036cf:	c9                   	leave  
  1036d0:	c3                   	ret    
