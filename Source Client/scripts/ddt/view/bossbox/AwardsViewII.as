package ddt.view.bossbox
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.manager.BossBoxManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mainbutton.MainButtnController;
   
   public class AwardsViewII extends Frame
   {
      
      public static const HAVEBTNCLICK:String = "_haveBtnClick";
       
      
      private var _timeTypeTxt:FilterFrameText;
      
      private var _goodsList:Array;
      
      private var _boxType:int;
      
      private var _button:TextButton;
      
      private var list:AwardsGoodsList;
      
      private var GoodsBG:ScaleBitmapImage;
      
      public function AwardsViewII()
      {
         super();
         this.initII();
         this.initEvent();
      }
      
      private function initII() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.timeBox.awardsInfo");
         this.GoodsBG = ComponentFactory.Instance.creat("bossbox.scale9GoodsImageII");
         addToContent(this.GoodsBG);
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.vip.monyBG");
         addToContent(_loc1_);
         this._timeTypeTxt = ComponentFactory.Instance.creat("bossbox.awardsTitleTxt");
         this._timeTypeTxt.text = LanguageMgr.GetTranslation("ddt.vip.awardsTitleTxt");
         addToContent(this._timeTypeTxt);
         this._button = ComponentFactory.Instance.creat("bossbox.BoxGetButtonII");
         this._button.text = LanguageMgr.GetTranslation("ok");
         addToContent(this._button);
         if(!PlayerManager.Instance.Self.IsVIP)
         {
            this._button.enable = false;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._button.addEventListener(MouseEvent.CLICK,this._click);
      }
      
      private function _click(param1:MouseEvent) : void
      {
         var _loc3_:BoxGoodsTempInfo = null;
         SoundManager.instance.play("008");
         var _loc2_:int = 0;
         for each(_loc3_ in this._goodsList)
         {
            if(_loc3_.TemplateId == -300)
            {
               _loc2_ = _loc3_.ItemCount;
               break;
            }
         }
         PlayerManager.Instance.Self.canTakeVipReward = false;
         MainButtnController.instance.dispatchEvent(new Event(MainButtnController.ICONCLOSE));
         dispatchEvent(new Event(AwardsView.HAVEBTNCLICK));
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      public function set boxType(param1:int) : void
      {
         this._boxType = param1 + 1;
      }
      
      public function get boxType() : int
      {
         return this._boxType;
      }
      
      public function set goodsList(param1:Array) : void
      {
         this._goodsList = param1;
         this.list = ComponentFactory.Instance.creatCustomObject("bossbox.AwardsGoodsList");
         this.list.show(this._goodsList);
         addChild(this.list);
      }
      
      public function set vipAwardGoodsList(param1:Array) : void
      {
         this._goodsList = param1;
         this.list = ComponentFactory.Instance.creatCustomObject("bossbox.AwardsGoodsList");
         this.list.showForVipAward(this._goodsList);
         addChild(this.list);
      }
      
      public function set fightLibAwardGoodList(param1:Array) : void
      {
         this.goodsList = param1;
         this.list = ComponentFactory.Instance.creatCustomObject("bossbox.AwardsGoodsList");
         this.list.show(this._goodsList);
         addChild(this.list);
      }
      
      public function setCheck() : void
      {
         closeButton.visible = true;
         this._button.enable = false;
         this._timeTypeTxt.visible = false;
         var _loc1_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("bossbox.TheNextTimeText");
         addToContent(_loc1_);
         _loc1_.text = LanguageMgr.GetTranslation("ddt.view.bossbox.AwardsView.TheNextTimeText",this.updateTime());
      }
      
      private function updateTime() : String
      {
         var _loc1_:Number = BossBoxManager.instance.delaySumTime * 1000 + TimeManager.Instance.Now().time;
         var _loc2_:Date = new Date(_loc1_);
         var _loc3_:int = _loc2_.hours;
         var _loc4_:int = _loc2_.minutes;
         var _loc5_:String = "";
         if(_loc3_ < 10)
         {
            _loc5_ += "0" + _loc3_;
         }
         else
         {
            _loc5_ += _loc3_;
         }
         _loc5_ += "点";
         if(_loc4_ < 10)
         {
            _loc5_ += "0" + _loc4_;
         }
         else
         {
            _loc5_ += _loc4_;
         }
         return _loc5_ + "分";
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         if(this._timeTypeTxt)
         {
            ObjectUtils.disposeObject(this._timeTypeTxt);
         }
         this._timeTypeTxt = null;
         if(this._button)
         {
            this._button.removeEventListener(MouseEvent.CLICK,this._click);
            ObjectUtils.disposeObject(this._button);
         }
         this._button = null;
         if(this.list)
         {
            ObjectUtils.disposeObject(this.list);
         }
         this.list = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
