// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.CSystem

package cmodule.decry
{
    public interface CSystem 
    {

        function tell(_arg_1:int):int;
        function access(_arg_1:int, _arg_2:int):int;
        function fsize(_arg_1:int):int;
        function open(_arg_1:int, _arg_2:int, _arg_3:int):int;
        function lseek(_arg_1:int, _arg_2:int, _arg_3:int):int;
        function setup(_arg_1:Function):void;
        function psize(_arg_1:int):int;
        function ioctl(_arg_1:int, _arg_2:int, _arg_3:int):int;
        function read(_arg_1:int, _arg_2:int, _arg_3:int):int;
        function getenv():Object;
        function close(_arg_1:int):int;
        function getargv():Array;
        function exit(_arg_1:int):void;
        function write(_arg_1:int, _arg_2:int, _arg_3:int):int;

    }
}//package cmodule.decry

