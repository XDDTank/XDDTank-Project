// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.movingNotification.MovingNotificationManager

package roomList.movingNotification
{
    import ddt.data.analyze.MovingNotificationAnalyzer;
    import flash.display.DisplayObjectContainer;

    public class MovingNotificationManager 
    {

        private static var _instance:MovingNotificationManager;

        private var _list:Array;
        private var _view:MovingNotificationView;

        public function MovingNotificationManager()
        {
            this._list = [];
        }

        public static function get Instance():MovingNotificationManager
        {
            if ((!(_instance)))
            {
                _instance = new (MovingNotificationManager)();
            };
            return (_instance);
        }


        public function setup(_arg_1:MovingNotificationAnalyzer):void
        {
            this._list = _arg_1.list;
        }

        public function showIn(_arg_1:DisplayObjectContainer):void
        {
            if ((!(this._view)))
            {
                this._view = new MovingNotificationView();
            };
            this._view.list = this._list;
            _arg_1.addChild(this._view);
        }

        public function get view():MovingNotificationView
        {
            return (this._view);
        }

        public function hide():void
        {
            if (this._view)
            {
                this._view.dispose();
            };
            this._view = null;
        }


    }
}//package roomList.movingNotification

