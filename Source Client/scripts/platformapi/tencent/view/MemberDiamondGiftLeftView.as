package platformapi.tencent.view
{
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DailyAwardType;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import platformapi.tencent.DiamondManager;
   import platformapi.tencent.DiamondType;
   
   public class MemberDiamondGiftLeftView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _buttenBG:ScaleBitmapImage;
      
      private var _openBtn:SimpleBitmapButton;
      
      private var _getBtn:SimpleBitmapButton;
      
      private var _vbox:VBox;
      
      private var _itmes:Array;
      
      private var _levelCount:int;
      
      public function MemberDiamondGiftLeftView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._levelCount = DiamondManager.instance.model.pfdata.pfType == DiamondType.BLUE_DIAMOND ? int(7) : int(8);
         this._bg = UICreatShortcut.creatAndAdd("MemberDiamondGiftRightView.core.scale9CornerImage22",this);
         this._buttenBG = UICreatShortcut.creatAndAdd("MemberDiamondGift.view.LeftBtnBG",this);
         this._vbox = UICreatShortcut.creatAndAdd("memberDiamondGift.view.MemberDiamondGiftLeftView.vbox",this);
         switch(DiamondManager.instance.model.pfdata.pfType)
         {
            case DiamondType.YELLOW_DIAMOND:
               this._openBtn = UICreatShortcut.creatAndAdd("MemberDiamondGift.view.LeftOpenBtn",this);
               this._getBtn = UICreatShortcut.creatAndAdd("MemberDiamondGift.view.leftgetBtn",this);
               PositionUtils.setPos(this._vbox,"memberDiamondGift.view.MemberDiamondGiftLeftView.vbox.yellow");
               break;
            case DiamondType.BLUE_DIAMOND:
               this._openBtn = UICreatShortcut.creatAndAdd("MemberDiamondGift.view.LeftOpenBtnI",this);
               this._getBtn = UICreatShortcut.creatAndAdd("MemberDiamondGift.view.leftgetBtnI",this);
               PositionUtils.setPos(this._vbox,"memberDiamondGift.view.MemberDiamondGiftLeftView.vbox.blue");
               break;
            case DiamondType.MEMBER_DIAMOND:
               this._openBtn = UICreatShortcut.creatAndAdd("MemberDiamondGift.view.LeftOpenBtnII",this);
               this._getBtn = UICreatShortcut.creatAndAdd("MemberDiamondGift.view.leftgetBtnII",this);
               PositionUtils.setPos(this._vbox,"memberDiamondGift.view.MemberDiamondGiftLeftView.vbox.memberQPlus");
         }
         this.createItem();
         if(PlayerManager.Instance.Self.MemberDiamondLevel > 0 && PlayerManager.Instance.Self.isYellowVip)
         {
            this._openBtn.visible = false;
            this._getBtn.visible = true;
         }
         else
         {
            this._openBtn.visible = true;
            this._getBtn.visible = false;
         }
         this._getBtn.enable = PlayerManager.Instance.Self.canTakeVIPPack;
      }
      
      private function createItem() : void
      {
         var _loc2_:MemberDiamondGiftItem = null;
         this._itmes = [];
         var _loc1_:int = 0;
         while(_loc1_ < this._levelCount)
         {
            _loc2_ = new MemberDiamondGiftItem(_loc1_ + 1);
            this._vbox.addChild(_loc2_);
            this._itmes.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function clearItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._levelCount)
         {
            this._itmes[_loc1_].dispose();
            this._itmes[_loc1_] = null;
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         this._openBtn.addEventListener(MouseEvent.CLICK,this.__onOpenBtnClick);
         this._getBtn.addEventListener(MouseEvent.CLICK,this.__ongetBtnClick);
         DiamondManager.instance.model.addEventListener(Event.CHANGE,this.__onUpdate);
      }
      
      private function removeEvent() : void
      {
         this._openBtn.removeEventListener(MouseEvent.CLICK,this.__onOpenBtnClick);
         this._getBtn.removeEventListener(MouseEvent.CLICK,this.__ongetBtnClick);
         DiamondManager.instance.model.removeEventListener(Event.CHANGE,this.__onUpdate);
      }
      
      protected function __onUpdate(param1:Event) : void
      {
      }
      
      private function __ongetBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(DiamondManager.instance.model.pfdata.pfType)
         {
            case DiamondType.YELLOW_DIAMOND:
               SocketManager.Instance.out.sendDiamondAward(DailyAwardType.MemberDimondAward);
               break;
            case DiamondType.BLUE_DIAMOND:
               SocketManager.Instance.out.sendDiamondAward(DailyAwardType.BlueMemberDimondAward);
               break;
            case DiamondType.MEMBER_DIAMOND:
               SocketManager.Instance.out.sendDiamondAward(DailyAwardType.memberQPlusAward);
         }
         PlayerManager.Instance.Self.canTakeVIPPack = false;
         this._getBtn.enable = false;
      }
      
      private function __onOpenBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         DiamondManager.instance.openMemberDiamond();
      }
      
      public function dispose() : void
      {
         this.clearItem();
         ObjectUtils.disposeObject(this._vbox);
         this._vbox = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._buttenBG);
         this._buttenBG = null;
         ObjectUtils.disposeObject(this._openBtn);
         this._openBtn = null;
         ObjectUtils.disposeObject(this._getBtn);
         this._getBtn = null;
      }
   }
}
