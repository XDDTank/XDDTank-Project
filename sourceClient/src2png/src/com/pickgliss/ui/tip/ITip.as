// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.tip.ITip

package com.pickgliss.ui.tip
{
    import flash.display.IDisplayObject;
    import com.pickgliss.ui.vo.DirectionPos;

    public interface ITip extends IDisplayObject 
    {

        function get tipData():Object;
        function set tipData(_arg_1:Object):void;
        function get currentDirectionPos():DirectionPos;
        function set currentDirectionPos(_arg_1:DirectionPos):void;

    }
}//package com.pickgliss.ui.tip

