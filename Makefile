test: test.o
	ld -o $@ $^ -N

%.o: %.nasm
	nasm -f elf64 $< -o $@ -g -F dwarf -l dump.lst

.PHONY: perf
# reading many performance counters is not good for a precise measurement, but we don't care now.
perf: test disable
	@perf stat -e \
	task-clock:u,\
	context-switches:u,\
	cpu-migrations:u,\
	page-faults:u,\
	cycles:u,\
	branches:u,\
	instructions:u,\
	uops_dispatched_port.port_0,\
	uops_dispatched_port.port_1,\
	uops_dispatched_port.port_2,\
	uops_dispatched_port.port_3,\
	uops_dispatched_port.port_4,\
	uops_dispatched_port.port_5,\
	uops_dispatched_port.port_6,\
	uops_dispatched_port.port_7,\
	uops_issued.any:u,\
	uops_executed.thread:u,\
	inst_retired.any_p,\
	idq.dsb_uops:u,\
	idq.all_dsb_cycles_any_uops,\
	idq.all_dsb_cycles_4_uops,\
	uops_issued.stall_cycles,\
	uops_retired.stall_cycles,\
	'cpu/event=0xA2,umask=0x4,name=resource_stalls.rs/u',\
	'cpu/event=0xa2,umask=0x40,name=resource_stalls_memrs_full/',\
	'cpu/event=0xA2,umask=0x10,name=resource_stalls.rob/u',\
	resource_stalls.any,\
	resource_stalls.sb,\
	l1d_pend_miss.fb_full,\
	l2_rqsts.all_rfo,\
	l2_rqsts.pf_hit,\
	l2_rqsts.miss,\
	mem_inst_retired.all_loads,\
	mem_inst_retired.all_stores,\
	machine_clears.smc,\
	machine_clears.count \
	-r2 ./$<

# disable as default SMT(Simultaneous Multi-threading Technology) and hardware-prefetching
disable:
	@echo off > /sys/devices/system/cpu/smt/control
	@echo 0 > /proc/sys/kernel/nmi_watchdog
	@wrmsr -a 0x1a4 15
