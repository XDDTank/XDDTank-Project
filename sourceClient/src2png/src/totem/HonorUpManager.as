// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.HonorUpManager

package totem
{
    import flash.events.EventDispatcher;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.comm.PackageIn;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import flash.events.Event;
    import totem.data.HonorUpDataAnalyz;

    public class HonorUpManager extends EventDispatcher 
    {

        public static const UP_COUNT_UPDATE:String = "up_count_update";
        private static var _instance:HonorUpManager;

        public var upCount:int = -1;
        private var _dataList:Array;

        public function HonorUpManager()
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HONOR_UP_COUNT, this.updateUpCount);
        }

        public static function get instance():HonorUpManager
        {
            if (_instance == null)
            {
                _instance = new (HonorUpManager)();
            };
            return (_instance);
        }


        public function get dataList():Array
        {
            return (this._dataList);
        }

        private function updateUpCount(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            if ((((!(this.upCount == -1)) && (!(this.upCount == _local_3))) && (!(_local_3 == 0))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.totem.honorUp.success", this.dataList[(_local_3 - 1)].honor), 0, true);
            };
            this.upCount = _local_3;
            dispatchEvent(new Event(UP_COUNT_UPDATE));
        }

        public function setup(_arg_1:HonorUpDataAnalyz):void
        {
            this._dataList = _arg_1.dataList;
        }


    }
}//package totem

