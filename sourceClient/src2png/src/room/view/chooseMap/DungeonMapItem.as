// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.chooseMap.DungeonMapItem

package room.view.chooseMap
{
    import flash.utils.Timer;
    import flash.display.Bitmap;
    import flash.events.TimerEvent;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class DungeonMapItem extends BaseMapItem 
    {

        private static const SHINE_DELAY:int = 200;

        private var _timer:Timer;
        private var _gainReduce:Bitmap;

        public function DungeonMapItem()
        {
            this._timer = new Timer(SHINE_DELAY);
            this._timer.addEventListener(TimerEvent.TIMER, this.__onTimer);
        }

        override protected function initView():void
        {
            super.initView();
            this._gainReduce = ComponentFactory.Instance.creatBitmap("asset.room.view.item.gainReduce");
            this._gainReduce.visible = false;
            addChild(this._gainReduce);
        }

        public function shine():void
        {
            this._timer.start();
        }

        public function stopShine():void
        {
            this._timer.stop();
            this._timer.reset();
            _selectedBg.visible = _selected;
        }

        private function __onTimer(_arg_1:TimerEvent):void
        {
            _selectedBg.visible = ((this._timer.currentCount % 2) == 1);
        }

        override public function set mapId(_arg_1:int):void
        {
            _mapId = _arg_1;
            this.updateMapIcon();
            buttonMode = ((mapId == -1) ? false : true);
        }

        override protected function updateMapIcon():void
        {
            var _local_1:Object = PlayerManager.Instance.Self.dungeonFlag;
            if (((_local_1) && (_local_1[_mapId] == 0)))
            {
                this._gainReduce.visible = true;
            }
            else
            {
                this._gainReduce.visible = false;
            };
            if (_mapId == -1)
            {
                ObjectUtils.disposeAllChildren(_mapIconContaioner);
                return;
            };
            super.updateMapIcon();
        }

        override public function dispose():void
        {
            this.stopShine();
            super.dispose();
        }


    }
}//package room.view.chooseMap

