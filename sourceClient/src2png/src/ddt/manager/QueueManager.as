// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.QueueManager

package ddt.manager
{
    import flash.events.Event;
    import flash.display.Stage;
    import ddt.events.CrazyTankSocketEvent;

    public class QueueManager 
    {

        private static var _executable:Array = new Array();
        public static var _waitlist:Array = new Array();
        private static var _lifeTime:int = 0;
        private static var _running:Boolean = true;
        private static var _diffTimeValue:int = 0;
        private static var _speedUp:int = 2;


        public static function get lifeTime():int
        {
            return (_lifeTime);
        }

        public static function setup(_arg_1:Stage):void
        {
            _arg_1.addEventListener(Event.ENTER_FRAME, frameHandler);
        }

        public static function pause():void
        {
            _running = false;
        }

        public static function resume():void
        {
            _running = true;
        }

        public static function setLifeTime(_arg_1:int):void
        {
            _lifeTime = _arg_1;
            _executable.concat(_waitlist);
        }

        public static function addQueue(_arg_1:CrazyTankSocketEvent):void
        {
            _waitlist.push(_arg_1);
        }

        private static function frameHandler(_arg_1:Event):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:CrazyTankSocketEvent;
            var _local_5:int;
            var _local_6:CrazyTankSocketEvent;
            var _local_7:int;
            _lifeTime++;
            if (_running)
            {
                _local_2 = 0;
                _local_3 = 0;
                _local_3 = 0;
                while (_local_3 < _waitlist.length)
                {
                    _local_6 = _waitlist[_local_3];
                    if (_local_6.pkg.extend2 <= _lifeTime)
                    {
                        _executable.push(_local_6);
                        _local_2++;
                    };
                    _local_3++;
                };
                for each (_local_4 in _executable)
                {
                    _local_7 = _waitlist.indexOf(_local_4);
                    if (_local_7 != -1)
                    {
                        _waitlist.splice(_local_7, 1);
                    };
                };
                _local_2 = 0;
                _local_5 = 0;
                while (_local_5 < _executable.length)
                {
                    if (_running)
                    {
                        dispatchEvent(_executable[_local_5]);
                        _local_2++;
                    };
                    _local_5++;
                };
                _executable.splice(0, _local_2);
            };
        }

        private static function dispatchEvent(event:Event):void
        {
            try
            {
                SocketManager.Instance.dispatchEvent(event);
            }
            catch(err:Error)
            {
                SocketManager.Instance.out.sendErrorMsg(((((("type:" + event.type) + "msg:") + err.message) + "\r\n") + err.getStackTrace()));
            };
        }


    }
}//package ddt.manager

