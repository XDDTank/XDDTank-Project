package vip.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class VipFrameHeadOne extends Sprite implements Disposeable
   {
       
      
      private var _topBG:ScaleBitmapImage;
      
      private var _buyPackageBtn:BaseButton;
      
      private var _dueDataWord:FilterFrameText;
      
      private var _dueData:FilterFrameText;
      
      private var _buyPackageTxt:FilterFrameText;
      
      private var _buyPackageTxt1:FilterFrameText;
      
      private var _price:int = 6680;
      
      public function VipFrameHeadOne()
      {
         super();
         this._init();
         this.addEvent();
      }
      
      private function _init() : void
      {
         this._topBG = ComponentFactory.Instance.creatComponentByStylename("VIPFrame.topBG1");
         this._buyPackageBtn = ComponentFactory.Instance.creatComponentByStylename("vip.buyPackageBtn");
         this._buyPackageTxt = ComponentFactory.Instance.creatComponentByStylename("vip.buyPackageTxt");
         this._buyPackageTxt.text = LanguageMgr.GetTranslation("ddt.vip.vipFrameHead.text");
         this._buyPackageTxt1 = ComponentFactory.Instance.creatComponentByStylename("vip.buyPackageTxt");
         PositionUtils.setPos(this._buyPackageTxt1,"buyPackagePos");
         this._buyPackageTxt1.text = LanguageMgr.GetTranslation("ddt.vip.vipFrameHead.text1");
         this._dueDataWord = ComponentFactory.Instance.creatComponentByStylename("VipStatusView.dueDateFontTxt");
         this._dueDataWord.text = LanguageMgr.GetTranslation("ddt.vip.dueDateFontTxt");
         PositionUtils.setPos(this._dueDataWord,"dueDataWordTxtPos");
         this._dueData = ComponentFactory.Instance.creat("VipStatusView.dueDate");
         PositionUtils.setPos(this._dueData,"dueDataTxtPos");
         addChild(this._topBG);
         addChild(this._buyPackageBtn);
         addChild(this._buyPackageTxt);
         addChild(this._buyPackageTxt1);
         addChild(this._dueDataWord);
         addChild(this._dueData);
         this.upView();
      }
      
      private function addEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this._buyPackageBtn.addEventListener(MouseEvent.CLICK,this.__onBuyClick);
      }
      
      private function __onBuyClick(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < this._price)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.vip.view.buyVipGift"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         _loc2_.mouseEnabled = false;
         _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseI);
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.dobuy();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function dobuy() : void
      {
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = [];
         var _loc7_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(EquipType.VIP_GIFT_BAG);
         _loc1_.push(_loc7_.TemplateID);
         _loc2_.push("1");
         _loc3_.push("");
         _loc4_.push("");
         _loc5_.push("");
         _loc6_.push("1");
         SocketManager.Instance.out.sendBuyGoods(_loc1_,_loc2_,_loc3_,_loc5_,_loc4_,null,0,_loc6_);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this._buyPackageBtn.removeEventListener(MouseEvent.CLICK,this.__onBuyClick);
      }
      
      private function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["isVip"] || param1.changedProperties["VipExpireDay"] || param1.changedProperties["VIPNextLevelDaysNeeded"])
         {
            this.upView();
         }
      }
      
      private function upView() : void
      {
         var _loc1_:Date = PlayerManager.Instance.Self.VIPExpireDay as Date;
         this._dueData.text = _loc1_.fullYear + "-" + (_loc1_.month + 1) + "-" + _loc1_.date;
         if(!PlayerManager.Instance.Self.IsVIP)
         {
            this._dueData.text = "";
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._topBG)
         {
            ObjectUtils.disposeObject(this._topBG);
         }
         this._topBG = null;
         if(this._buyPackageTxt)
         {
            ObjectUtils.disposeObject(this._buyPackageTxt);
         }
         this._buyPackageTxt = null;
         if(this._buyPackageTxt1)
         {
            ObjectUtils.disposeObject(this._buyPackageTxt1);
         }
         this._buyPackageTxt1 = null;
      }
   }
}
