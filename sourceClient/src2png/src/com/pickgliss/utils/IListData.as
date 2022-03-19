// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.utils.IListData

package com.pickgliss.utils
{
    public interface IListData 
    {

        function get(_arg_1:int):*;
        function append(_arg_1:*, _arg_2:int=-1):void;
        function appendAll(_arg_1:Array, _arg_2:int=-1):void;
        function appendList(_arg_1:IListData, _arg_2:int=-1):void;
        function replaceAt(_arg_1:int, _arg_2:*):*;
        function removeAt(_arg_1:int):*;
        function remove(_arg_1:*):*;
        function removeRange(_arg_1:int, _arg_2:int):Array;
        function indexOf(_arg_1:*):int;
        function contains(_arg_1:*):Boolean;
        function first():*;
        function last():*;
        function pop():*;
        function shift():*;
        function size():int;
        function clear():void;
        function isEmpty():Boolean;
        function toArray():Array;

    }
}//package com.pickgliss.utils

