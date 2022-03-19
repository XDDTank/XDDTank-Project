// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.core.IViewprot

package com.pickgliss.ui.core
{
    import flash.display.IDisplayObject;
    import com.pickgliss.geom.IntDimension;
    import com.pickgliss.geom.IntPoint;
    import com.pickgliss.geom.IntRectangle;

    [Event(name="stateChanged", type="org.aswing.event.InteractiveEvent")]
    public interface IViewprot extends IDisplayObject 
    {

        function get verticalUnitIncrement():int;
        function get verticalBlockIncrement():int;
        function get horizontalUnitIncrement():int;
        function get horizontalBlockIncrement():int;
        function set verticalUnitIncrement(_arg_1:int):void;
        function set verticalBlockIncrement(_arg_1:int):void;
        function set horizontalUnitIncrement(_arg_1:int):void;
        function set horizontalBlockIncrement(_arg_1:int):void;
        function setViewportTestSize(_arg_1:IntDimension):void;
        function getExtentSize():IntDimension;
        function getViewSize():IntDimension;
        function get viewPosition():IntPoint;
        function set viewPosition(_arg_1:IntPoint):void;
        function scrollRectToVisible(_arg_1:IntRectangle):void;
        function addStateListener(_arg_1:Function, _arg_2:int=0, _arg_3:Boolean=false):void;
        function removeStateListener(_arg_1:Function):void;
        function getViewportPane():Component;

    }
}//package com.pickgliss.ui.core

