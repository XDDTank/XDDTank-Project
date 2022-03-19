// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.UICreatShortcut

package com.pickgliss.ui
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.text.TextField;

    public class UICreatShortcut 
    {


        public static function creatAndAdd(_arg_1:String="", _arg_2:DisplayObjectContainer=null):*
        {
            var _local_3:DisplayObject = ComponentFactory.Instance.creat(_arg_1);
            return (_arg_2.addChild(_local_3));
        }

        public static function creatTextAndAdd(_arg_1:String="", _arg_2:String="", _arg_3:DisplayObjectContainer=null):*
        {
            var _local_4:TextField = ComponentFactory.Instance.creat(_arg_1);
            _local_4.text = _arg_2;
            return (_arg_3.addChild(_local_4));
        }


    }
}//package com.pickgliss.ui

