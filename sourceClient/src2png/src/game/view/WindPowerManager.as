// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.WindPowerManager

package game.view
{
    import game.model.WindPowerImgData;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.comm.PackageIn;
    import flash.utils.ByteArray;
    import flash.display.BitmapData;

    public class WindPowerManager 
    {

        private static var _instance:WindPowerManager;

        private var _windPicMode:WindPowerImgData;


        public static function get Instance():WindPowerManager
        {
            if (_instance == null)
            {
                _instance = new (WindPowerManager)();
            };
            return (_instance);
        }


        public function init():void
        {
            this._windPicMode = new WindPowerImgData();
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WINDPIC, this._windPicCome);
        }

        private function _windPicCome(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readByte();
            var _local_4:ByteArray = _local_2.readByteArray();
            this._windPicMode.refeshData(_local_4, _local_3);
        }

        public function getWindPic(_arg_1:Array):BitmapData
        {
            return (this._windPicMode.getImgBmp(_arg_1));
        }

        public function getWindPicById(_arg_1:int):BitmapData
        {
            return (this._windPicMode.getImgBmpById(_arg_1));
        }


    }
}//package game.view

