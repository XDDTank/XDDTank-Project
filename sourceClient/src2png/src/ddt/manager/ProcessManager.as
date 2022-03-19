// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.ProcessManager

package ddt.manager
{
    import __AS3__.vec.Vector;
    import ddt.interfaces.IProcessObject;
    import flash.display.Shape;
    import flash.utils.getTimer;
    import flash.events.Event;
    import __AS3__.vec.*;

    public class ProcessManager 
    {

        private static var _ins:ProcessManager;

        private var _objects:Vector.<IProcessObject> = new Vector.<IProcessObject>();
        private var _startup:Boolean = false;
        private var _shape:Shape = new Shape();
        private var _elapsed:int;
        private var _virtualTime:int;


        public static function get Instance():ProcessManager
        {
            return (_ins = ((_ins) || (new (ProcessManager)())));
        }


        public function addObject(_arg_1:IProcessObject):IProcessObject
        {
            if ((!(_arg_1.onProcess)))
            {
                _arg_1.onProcess = true;
                this._objects.push(_arg_1);
                this.startup();
            };
            return (_arg_1);
        }

        public function removeObject(_arg_1:IProcessObject):IProcessObject
        {
            var _local_2:int;
            if (_arg_1.onProcess)
            {
                _arg_1.onProcess = false;
                _local_2 = this._objects.indexOf(_arg_1);
                if (_local_2 >= 0)
                {
                    this._objects.splice(_local_2, 1);
                };
            };
            return (_arg_1);
        }

        public function startup():void
        {
            if ((!(this._startup)))
            {
                this._elapsed = getTimer();
                this._shape.addEventListener(Event.ENTER_FRAME, this.__enterFrame);
                this._startup = true;
            };
        }

        private function __enterFrame(_arg_1:Event):void
        {
            var _local_4:IProcessObject;
            var _local_2:int = getTimer();
            var _local_3:Number = (_local_2 - this._elapsed);
            for each (_local_4 in this._objects)
            {
                _local_4.process(_local_3);
            };
            this._elapsed = _local_2;
        }

        public function shutdown():void
        {
            this._shape.removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
            this._startup = false;
        }

        public function get running():Boolean
        {
            return (this._startup);
        }


    }
}//package ddt.manager

