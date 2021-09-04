package platformapi.tencent.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DailyAwardType;
   import ddt.data.DaylyGiveInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import platformapi.tencent.DiamondManager;
   import platformapi.tencent.DiamondType;
   
   public class MemberDiamondGiftRightView extends Sprite implements Disposeable
   {
       
      
      private var _title:Bitmap;
      
      private var _titleII:Bitmap;
      
      private var _bg:Scale9CornerImage;
      
      private var _bgII:Scale9CornerImage;
      
      private var _buttenBG:ScaleBitmapImage;
      
      private var _openBtn:SimpleBitmapButton;
      
      private var _getBtn:SimpleBitmapButton;
      
      private var _simpleTitleList:SimpleTileList;
      
      private var _cells:Vector.<MemberDiamondGiftCell>;
      
      public function MemberDiamondGiftRightView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._bg = UICreatShortcut.creatAndAdd("MemberDiamondGift.view.Scale9CornerImage2",this);
         this._bgII = UICreatShortcut.creatAndAdd("MemberDiamondGift.view.Scale9CornerImage1",this);
         this._buttenBG = UICreatShortcut.creatAndAdd("MemberDiamondGift.view.RightBtnBG",this);
         switch(DiamondManager.instance.model.pfdata.pfType)
         {
            case DiamondType.YELLOW_DIAMOND:
               this._title = UICreatShortcut.creatAndAdd("asset.MemberDiamondGift.rightTitle",this);
               this._openBtn = UICreatShortcut.creatAndAdd("MemberDiamondGift.view.RightOpenBtn",this);
               this._getBtn = UICreatShortcut.creatAndAdd("MemberDiamondGift.view.rightgetBtn",this);
               break;
            case DiamondType.BLUE_DIAMOND:
               this._title = UICreatShortcut.creatAndAdd("asset.MemberDiamondGift.BluerightTitle",this);
               this._openBtn = UICreatShortcut.creatAndAdd("MemberDiamondGift.view.RightOpenBtnI",this);
               this._getBtn = UICreatShortcut.creatAndAdd("MemberDiamondGift.view.rightgetBtnI",this);
               break;
            case DiamondType.MEMBER_DIAMOND:
               this._title = UICreatShortcut.creatAndAdd("asset.MemberDiamondGift.memberQPlusRightTitle",this);
               this._openBtn = UICreatShortcut.creatAndAdd("MemberDiamondGift.view.RightOpenBtnII",this);
               this._getBtn = UICreatShortcut.creatAndAdd("MemberDiamondGift.view.rightgetBtnII",this);
         }
         this._getBtn.enable = PlayerManager.Instance.Self.canTakeVIPYearPack;
         this._titleII = UICreatShortcut.creatAndAdd("asset.MemberDiamondGift.rightTitleII",this);
         this._simpleTitleList = ComponentFactory.Instance.creat("memberDiamondGift.view.MemberDiamondGiftRightView.simpleTitleList",[2]);
         addChild(this._simpleTitleList);
         this.createCell();
         this.update();
      }
      
      private function createCell() : void
      {
         var _loc2_:MemberDiamondGiftCell = null;
         this._cells = new Vector.<MemberDiamondGiftCell>();
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = new MemberDiamondGiftCell(_loc1_);
            this._simpleTitleList.addChild(_loc2_);
            this._cells.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function update() : void
      {
         var _loc1_:Array = DiamondManager.instance.model.yearAwardList.list[0];
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this._cells[_loc2_].setInfo(_loc1_[_loc2_] as DaylyGiveInfo);
            _loc2_++;
         }
         if(PlayerManager.Instance.Self.MemberDiamondLevel > 0 && PlayerManager.Instance.Self.isYearVip && PlayerManager.Instance.Self.isYellowVip)
         {
            this._openBtn.visible = false;
            this._getBtn.visible = true;
         }
         else
         {
            this._openBtn.visible = true;
            this._getBtn.visible = false;
         }
      }
      
      private function clearCell() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this._cells[_loc1_].dispose();
            this._cells[_loc1_] = null;
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
         this.update();
      }
      
      private function __ongetBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(DiamondManager.instance.model.pfdata.pfType)
         {
            case DiamondType.YELLOW_DIAMOND:
               SocketManager.Instance.out.sendDiamondAward(DailyAwardType.YearMemberDimondAward);
               break;
            case DiamondType.BLUE_DIAMOND:
               SocketManager.Instance.out.sendDiamondAward(DailyAwardType.BlueYearMemberDimondAward);
               break;
            case DiamondType.MEMBER_DIAMOND:
               SocketManager.Instance.out.sendDiamondAward(DailyAwardType.memberQPlusYearAward);
         }
         PlayerManager.Instance.Self.canTakeVIPYearPack = false;
         this._getBtn.enable = false;
      }
      
      private function __onOpenBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         DiamondManager.instance.openYearMemberDiamond();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clearCell();
         ObjectUtils.disposeObject(this._title);
         this._title = null;
         ObjectUtils.disposeObject(this._titleII);
         this._titleII = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._bgII);
         this._bgII = null;
         ObjectUtils.disposeObject(this._buttenBG);
         this._buttenBG = null;
         ObjectUtils.disposeObject(this._openBtn);
         this._openBtn = null;
         ObjectUtils.disposeObject(this._getBtn);
         this._getBtn = null;
      }
   }
}
