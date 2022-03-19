// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.others.PetOtherInfoView

package petsBag.view.others
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.ScrollPanel;
    import petsBag.view.list.PetInfoList;
    import bagAndInfo.bag.PlayerPersonView;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.ui.ComponentFactory;
    import petsBag.event.PetItemEvent;
    import pet.date.PetInfo;
    import ddt.manager.PetInfoManager;
    import com.pickgliss.utils.ObjectUtils;

    public class PetOtherInfoView extends Sprite implements Disposeable 
    {

        private var _scroll:ScrollPanel;
        private var _petInfoList:PetInfoList;
        private var _infoView:PetOtherRightInfoView;
        private var _playerView:PlayerPersonView;
        private var _info:PlayerInfo;

        public function PetOtherInfoView()
        {
            this.init();
            this.initEvent();
        }

        private function findDefaultIndex():int
        {
            var _local_1:int;
            while (_local_1 < this._petInfoList.items.length)
            {
                if (this._petInfoList.items[_local_1].Place == 0)
                {
                    return (_local_1);
                };
                _local_1++;
            };
            return (0);
        }

        protected function init():void
        {
            this._infoView = ComponentFactory.Instance.creat("petsBag.view.other.petInfoView");
            addChild(this._infoView);
            this._petInfoList = ComponentFactory.Instance.creat("petsBag.view.other.petInfoList", [8]);
            addChild(this._petInfoList);
            this._scroll = ComponentFactory.Instance.creat("petsBag.view.other.petInfoList.scroll");
            this._scroll.setView(this._petInfoList);
            addChild(this._scroll);
            this._playerView = ComponentFactory.Instance.creat("petsBag.view.other.playerView");
            this._playerView.setHpVisble(false);
            addChild(this._playerView);
        }

        private function initEvent():void
        {
            this._petInfoList.addEventListener(PetItemEvent.ITEM_CHANGE, this.__itemChange);
        }

        private function removeEvent():void
        {
            this._petInfoList.removeEventListener(PetItemEvent.ITEM_CHANGE, this.__itemChange);
        }

        protected function __itemChange(_arg_1:PetItemEvent):void
        {
            this._infoView.info = (_arg_1.data as PetInfo);
        }

        public function get info():PlayerInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:PlayerInfo):void
        {
            this._info = _arg_1;
            this._petInfoList.items = PetInfoManager.instance.getpetListSorted(this._info.pets);
            this._scroll.invalidateViewport();
            this._petInfoList.selectedIndex = this.findDefaultIndex();
            this._playerView.info = this._info;
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._scroll);
            this._scroll = null;
            this._petInfoList = null;
            ObjectUtils.disposeObject(this._petInfoList);
            this._petInfoList = null;
            ObjectUtils.disposeObject(this._playerView);
            this._playerView = null;
            this._info = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package petsBag.view.others

