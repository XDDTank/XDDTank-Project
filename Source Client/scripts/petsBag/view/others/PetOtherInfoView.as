package petsBag.view.others
{
   import bagAndInfo.bag.PlayerPersonView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PetInfoManager;
   import flash.display.Sprite;
   import pet.date.PetInfo;
   import petsBag.event.PetItemEvent;
   import petsBag.view.list.PetInfoList;
   
   public class PetOtherInfoView extends Sprite implements Disposeable
   {
       
      
      private var _scroll:ScrollPanel;
      
      private var _petInfoList:PetInfoList;
      
      private var _infoView:PetOtherRightInfoView;
      
      private var _playerView:PlayerPersonView;
      
      private var _info:PlayerInfo;
      
      public function PetOtherInfoView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function findDefaultIndex() : int
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._petInfoList.items.length)
         {
            if(this._petInfoList.items[_loc1_].Place == 0)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return 0;
      }
      
      protected function init() : void
      {
         this._infoView = ComponentFactory.Instance.creat("petsBag.view.other.petInfoView");
         addChild(this._infoView);
         this._petInfoList = ComponentFactory.Instance.creat("petsBag.view.other.petInfoList",[8]);
         addChild(this._petInfoList);
         this._scroll = ComponentFactory.Instance.creat("petsBag.view.other.petInfoList.scroll");
         this._scroll.setView(this._petInfoList);
         addChild(this._scroll);
         this._playerView = ComponentFactory.Instance.creat("petsBag.view.other.playerView");
         this._playerView.setHpVisble(false);
         addChild(this._playerView);
      }
      
      private function initEvent() : void
      {
         this._petInfoList.addEventListener(PetItemEvent.ITEM_CHANGE,this.__itemChange);
      }
      
      private function removeEvent() : void
      {
         this._petInfoList.removeEventListener(PetItemEvent.ITEM_CHANGE,this.__itemChange);
      }
      
      protected function __itemChange(param1:PetItemEvent) : void
      {
         this._infoView.info = param1.data as PetInfo;
      }
      
      public function get info() : PlayerInfo
      {
         return this._info;
      }
      
      public function set info(param1:PlayerInfo) : void
      {
         this._info = param1;
         this._petInfoList.items = PetInfoManager.instance.getpetListSorted(this._info.pets);
         this._scroll.invalidateViewport();
         this._petInfoList.selectedIndex = this.findDefaultIndex();
         this._playerView.info = this._info;
      }
      
      public function dispose() : void
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
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
