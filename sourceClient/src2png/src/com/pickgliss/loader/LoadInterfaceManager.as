// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.loader.LoadInterfaceManager

package com.pickgliss.loader
{
    import flash.events.EventDispatcher;
    import flash.external.ExternalInterface;
    import flash.system.fscommand;

    public class LoadInterfaceManager 
    {

        private static var _eventDispatcher:EventDispatcher = new EventDispatcher();


        [Event(name="checkComplete", type="com.pickgliss.loader.LoadInterfaceEvent")]
        [Event(name="deleteComplete", type="com.pickgliss.loader.LoadInterfaceEvent")]
        [Event(name="flashGotoAndPlay", type="com.pickgliss.loader.LoadInterfaceEvent")]
        [Event(name="setSound", type="com.pickgliss.loader.LoadInterfaceEvent")]
        public static function get eventDispatcher():EventDispatcher
        {
            return (_eventDispatcher);
        }

        public static function checkClientType():void
        {
            if (ExternalInterface.available)
            {
                fscommand("checkLoginType");
                ExternalInterface.call("checkLoginType");
            }
            else
            {
                LoadResourceManager.instance.setLoginType(0);
            };
        }

        public static function initAppInterface():void
        {
            if (ExternalInterface.available)
            {
                ExternalInterface.addCallback("setLoginType", LoadResourceManager.instance.setLoginType);
                ExternalInterface.addCallback("checkComplete", __checkHandler);
                ExternalInterface.addCallback("deleteComplete", __deleteHandler);
                ExternalInterface.addCallback("flashGotoAndPlay", __flashGotoAndPlayHandler);
                ExternalInterface.addCallback("setSound", __setSoundHandler);
            };
        }

        private static function __checkHandler(... _args):void
        {
            _eventDispatcher.dispatchEvent(new LoadInterfaceEvent(LoadInterfaceEvent.CHECK_COMPLETE, _args));
        }

        private static function __deleteHandler(... _args):void
        {
            _eventDispatcher.dispatchEvent(new LoadInterfaceEvent(LoadInterfaceEvent.DELETE_COMPLETE, _args));
        }

        private static function __flashGotoAndPlayHandler(... _args):void
        {
            _eventDispatcher.dispatchEvent(new LoadInterfaceEvent(LoadInterfaceEvent.FLASH_GOTO_AND_PLAY, _args));
        }

        private static function __setSoundHandler(... _args):void
        {
            _eventDispatcher.dispatchEvent(new LoadInterfaceEvent(LoadInterfaceEvent.SET_SOUND, _args));
        }

        public static function setVersion(_arg_1:int):void
        {
            LoadInterfaceManager.traceMsg(("setVersion:" + _arg_1));
            if (ExternalInterface.available)
            {
                fscommand("setVersion", _arg_1.toString());
            };
        }

        public static function checkResource(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:Boolean=false):void
        {
            LoadInterfaceManager.traceMsg(("checkResource:" + [_arg_1, _arg_2, _arg_3, _arg_4].join("|")));
            if (ExternalInterface.available)
            {
                fscommand("checkResource", [_arg_1, _arg_2, _arg_3, _arg_4].join("|"));
            };
        }

        public static function deleteResource(_arg_1:String):void
        {
            LoadInterfaceManager.traceMsg(("deleteResource:" + _arg_1));
            if (ExternalInterface.available)
            {
                fscommand("deleteResource", _arg_1);
            };
        }

        public static function traceMsg(_arg_1:String):void
        {
            if (ExternalInterface.available)
            {
                ExternalInterface.call("debugTrace", _arg_1);
            };
            if (ExternalInterface.available)
            {
                fscommand("printTest", _arg_1);
            };
        }

        public static function alertAndRestart(_arg_1:String):void
        {
            if (ExternalInterface.available)
            {
                traceMsg(("alertAndRestart:" + _arg_1));
                fscommand("alertAndRestart", _arg_1);
            };
        }

        public static function setDailyTask(_arg_1:String):void
        {
            if (ExternalInterface.available)
            {
                traceMsg(("setDailyTask:" + _arg_1));
                fscommand("setDailyTask", _arg_1);
            };
        }

        public static function setDailyActivity(_arg_1:String):void
        {
            if (ExternalInterface.available)
            {
                traceMsg(("setDailyActivity:" + _arg_1));
                fscommand("setDailyActivity", _arg_1);
            };
        }

        public static function setFatigue(_arg_1:String):void
        {
            if (ExternalInterface.available)
            {
                traceMsg(("setFatigue:" + _arg_1));
                fscommand("setFatigue", _arg_1);
            };
        }

        public static function setSound(_arg_1:String):void
        {
            if (ExternalInterface.available)
            {
                traceMsg(("setSound:" + _arg_1));
                fscommand("setSound", _arg_1);
            };
        }

        public static function SyncDesktopTimer(_arg_1:String):void
        {
            if (ExternalInterface.available)
            {
                traceMsg(("SyncDesktopTimer:" + _arg_1));
                fscommand("SyncDesktopTimer", _arg_1);
            };
        }


    }
}//package com.pickgliss.loader

