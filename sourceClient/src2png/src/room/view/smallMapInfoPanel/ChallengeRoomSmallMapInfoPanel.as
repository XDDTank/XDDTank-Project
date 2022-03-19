// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.smallMapInfoPanel.ChallengeRoomSmallMapInfoPanel

package room.view.smallMapInfoPanel
{
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.loader.DisplayLoader;
    import flash.display.Sprite;
    import com.pickgliss.utils.ObjectUtils;
    import room.events.RoomPlayerEvent;
    import flash.events.MouseEvent;
    import room.model.RoomInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SoundManager;
    import room.view.chooseMap.ChallengeChooseMapView;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;
    import flash.display.Bitmap;
    import ddt.manager.PathManager;

    public class ChallengeRoomSmallMapInfoPanel extends MatchRoomSmallMapInfoPanel implements Disposeable 
    {

        private var _titleLoader:DisplayLoader;
        private var _titleIconContainer:Sprite;


        override public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this._titleIconContainer);
            _info.selfRoomPlayer.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE, this.__update);
            super.dispose();
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        override public function set info(_arg_1:RoomInfo):void
        {
            super.info = _arg_1;
            if (_info)
            {
                _info.selfRoomPlayer.addEventListener(RoomPlayerEvent.IS_HOST_CHANGE, this.__update);
            };
            if (((_info) && (_info.selfRoomPlayer.isHost)))
            {
                buttonMode = true;
                addEventListener(MouseEvent.CLICK, this.__onClick);
            }
            else
            {
                buttonMode = true;
                removeEventListener(MouseEvent.CLICK, this.__onClick);
            };
            this.__update();
        }

        public function shine():void
        {
        }

        public function stopShine():void
        {
        }

        override protected function initView():void
        {
            super.initView();
            this._titleIconContainer = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.challenge.chooseMap.titleSprite");
            _timeType.setFrame(2);
            addChild(this._titleIconContainer);
            this._titleIconContainer.visible = false;
            buttonMode = true;
        }

        override protected function __onClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("045");
            var _local_2:ChallengeChooseMapView = new ChallengeChooseMapView();
            _local_2.show();
        }

        private function __update(_arg_1:RoomPlayerEvent=null):void
        {
            if (_info.selfRoomPlayer.isHost)
            {
                addEventListener(MouseEvent.CLICK, this.__onClick);
            }
            else
            {
                removeEventListener(MouseEvent.CLICK, this.__onClick);
            };
        }

        override protected function updateView():void
        {
            this._titleIconContainer.visible = (!(_info.mapId == 0));
            super.updateView();
            if (this._titleLoader)
            {
                this._titleLoader = null;
            };
            this._titleLoader = LoadResourceManager.instance.createLoader(this.titlePath(), BaseLoader.BITMAP_LOADER);
            this._titleLoader.addEventListener(LoaderEvent.COMPLETE, this.__titleCompleteHandler);
            LoadResourceManager.instance.startLoad(this._titleLoader);
        }

        private function __titleCompleteHandler(_arg_1:LoaderEvent):void
        {
            ObjectUtils.disposeAllChildren(this._titleIconContainer);
            if (_arg_1.loader.isSuccess)
            {
                _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, this.__titleCompleteHandler);
                this._titleIconContainer.addChild((_arg_1.loader.content as Bitmap));
            };
        }

        private function titlePath():String
        {
            if (((_info) && (_info.mapId > 0)))
            {
                return (((PathManager.SITE_MAIN + "image/map/") + _info.mapId.toString()) + "/icon.png");
            };
            return (PathManager.SITE_MAIN + "image/map/0/icon.png");
        }


    }
}//package room.view.smallMapInfoPanel

