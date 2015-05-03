@echo off
echo 0-------------------------------------------------------0
echo 1                                                       1
echo 1   File Name: Buildwin.bat                             1
echo 1   Description: Operating System Compiler              1
echo 1                                                       1
echo 1   Visual Software Operating System                    1
echo 1                                                       1
echo 0-------------------------------------------------------0
echo.
echo Building Visual Software Operating System...
echo.

mkdir Bin
echo Assembling Bootloader...
nasm -O0 -f bin -o bootload/bootload.bin bootload/bootload.asm

echo Assembling Kernel...
nasm -O0 -f bin kernel\kernel.asm -o kernel\KERNEL.bin

echo Assembling programs...
cd apps
 for %%i in (*.asm) do ..\nasm -O0 -fbin %%i
 for %%i in (*.bin) do del %%i
 for %%i in (*.) do ren %%i %%i.bin
cd ..

echo Adding bootsector to disk image...
partcopy bootload\bootload.bin 0 200 bin\vsos.flp 0

echo Mounting disk image...
imdisk -a -f bin\vsos.flp -s 1440K -m B:

echo Copying kernel and applications to disk image...
copy Kernel\KERNEL.bin b:\
copy include\*.* b:\
copy apps\*.bin b:\
copy apps\*.bas b:\

echo Dismounting disk image...
imdisk -D -m B:

echo Finished!
