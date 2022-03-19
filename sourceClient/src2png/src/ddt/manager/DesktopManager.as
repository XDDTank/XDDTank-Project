﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.DesktopManager

package ddt.manager
{
    import flash.external.ExternalInterface;

    public class DesktopManager 
    {

        private static var _instance:DesktopManager;

        private var _desktopType:int;


        public static function get Instance():DesktopManager
        {
            if (_instance == null)
            {
                _instance = new (DesktopManager)();
            };
            return (_instance);
        }


        public function checkIsDesktop():void
        {
            if (ExternalInterface.available)
            {
                ExternalInterface.addCallback("SetIsDesktop", this.SetIsDesktop);
                ExternalInterface.call("IsDesktop");
            };
        }

        private function SetIsDesktop():void
        {
            this._desktopType = 1;
        }

        public function get isDesktop():Boolean
        {
            return (this._desktopType > 0);
        }

        public function get desktopType():int
        {
            return (this._desktopType);
        }

        public function backToLogin():void
        {
            ExternalInterface.call("WindowReturn");
        }


    }
}//package ddt.manager
