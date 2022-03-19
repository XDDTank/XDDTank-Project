// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.ComponentSetting

package com.pickgliss.ui
{
    import com.greensock.easing.Sine;
    import flash.display.DisplayObjectContainer;

    public final class ComponentSetting 
    {

        public static var BUTTON_PRESS_START_TIME:int = 500;
        public static var BUTTON_PRESS_STEP_TIME:int = 100;
        public static var COMBOBOX_HIDE_EASE_FUNCTION:Function = Sine.easeIn;
        public static var COMBOBOX_HIDE_TIME:Number = 0;
        public static var COMBOBOX_SHOW_EASE_FUNCTION:Function = Sine.easeInOut;
        public static var COMBOBOX_SHOW_TIME:Number = 0.5;
        public static var BITMAPDATA_TAG_NAME:String = "bitmapData";
        public static var BITMAP_TAG_NAME:String = "bitmap";
        public static var SIMPLE_ALERT_STYLE:String = "SimpleAlert";
        public static var SIMPLE_BITMAP_BUTTON_FILTER:String = "null,lightFilter,null,grayFilter";
        public static var ALERT_BUTTON_GAPE:int = 30;
        public static var COMBOX_LIST_LAYER:DisplayObjectContainer;
        public static var SCROLL_UINT_INCREMENT:int = 15;
        public static var SCROLL_BLOCK_INCREMENT:int = 20;
        public static var DISPLACEMENT_OFFSET:uint = 1;
        public static var LANGUAGE:String;
        public static var USEMD5:Boolean = false;
        public static var ResloveConfigXMLPathCall:Function = null;
        public static var ResloveConfigZipPathCall:Function = null;
        public static var ResloveTempleteZipPathCall:Function = null;
        public static var ResloveConfigUISourcePathCall:Function = null;
        public static var PLAY_SOUND_FUNC:Function = null;
        public static var SEND_USELOG_ID:Function = null;
        public static const ALPHA_LAYER_FILTER:String = "alphaLayerGilter";
        public static const CORE_MODULE_NAME:String = "core.xml";
        public static const DEFAULT_ICON_WIDTH:int = 78;
        public static const DEFAULT_ICON_HEIGHT:int = 78;
        public static var FLASHSITE:String = "";
        public static var BACKUP_FLASHSITE:String = "";
        public static const MD5_OBJECT:Array = [".swf", ".png"];
        public static var md5Dic:Object = new Object();
        public static var swf_head:String = "road7";


        public static function getUIConfigXMLPath(_arg_1:String):String
        {
            if (ResloveConfigXMLPathCall == null)
            {
                return (((("ui/" + LANGUAGE) + "/xml/") + _arg_1) + ".xml");
            };
            return (ResloveConfigXMLPathCall(_arg_1));
        }

        public static function getUIConfigZIPPath():String
        {
            if (ResloveConfigZipPathCall == null)
            {
                return (("ui/" + LANGUAGE) + "/xml/xml.png");
            };
            return (ResloveConfigZipPathCall());
        }

        public static function getTempleteZIPPath():String
        {
            if (ResloveConfigZipPathCall == null)
            {
                return ("xmldata.xml");
            };
            return (ResloveConfigZipPathCall());
        }

        public static function getUISourcePath(_arg_1:String):String
        {
            if (ResloveConfigUISourcePathCall == null)
            {
                return (((("ui/" + LANGUAGE) + "/swf/") + _arg_1) + ".swf");
            };
            return (ResloveConfigUISourcePathCall(_arg_1));
        }


    }
}//package com.pickgliss.ui

