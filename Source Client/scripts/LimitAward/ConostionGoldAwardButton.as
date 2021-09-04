package LimitAward
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConosrtionTimerManager;
   import ddt.data.BuffInfo;
   import ddt.events.TimeEvents;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ConostionGoldAwardButton extends Component
   {
       
      
      private var _timeBg:Bitmap;
      
      private var _btnBg:ScaleFrameImage;
      
      private var _timerTxt:FilterFrameText;
      
      private var _tips:OneLineTip;
      
      private var _tipsTxt:FilterFrameText;
      
      private var _buffinfo:BuffInfo;
      
      public function ConostionGoldAwardButton()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         buttonMode = true;
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.GoldBtn");
         this._timeBg = ComponentFactory.Instance.creatBitmap("asset.ddthall.goldBox.timeBG");
         this._btnBg.setFrame(1);
         this._timerTxt = ComponentFactory.Instance.creatComponentByStylename("Consorionshop.goldtimerTxt");
         this._tipsTxt = ComponentFactory.Instance.creatComponentByStylename("Consorionshop.goldtimerTxt");
         this._tips = new OneLineTip();
         this._tips.visible = false;
         this._buffinfo = PlayerManager.Instance.Self.buffInfo[BuffInfo.GET_ONLINE_REWARS];
         this._btnBg.buttonMode = true;
         addChild(this._btnBg);
         addChild(this._timeBg);
         addChild(this._timerTxt);
      }
      
      private function initEvent() : void
      {
         TimeManager.addEventListener(TimeEvents.SECONDS,this.__upTimer);
         addEventListener(MouseEvent.CLICK,this.__openAwardFrame);
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function removeEvent() : void
      {
         TimeManager.removeEventListener(TimeEvents.SECONDS,this.__upTimer);
         removeEventListener(MouseEvent.CLICK,this.__openAwardFrame);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function __openAwardFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._tips)
         {
            this._tips.visible = false;
         }
         var _loc2_:ConsortionAwardFrame = ComponentFactory.Instance.creatComponentByStylename("ConsortionAwardFrame");
         _loc2_.show();
      }
      
      private function __mouseOver(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Point = null;
         if(this._tips)
         {
            _loc2_ = TimeManager.Instance.formatTimeToString1(ConosrtionTimerManager.Instance.count * 1000,false);
            _loc3_ = _loc2_.split(":");
            this._tipsTxt.htmlText = LanguageMgr.GetTranslation("ddt.consortionGold.awardTips",_loc3_[0],_loc3_[1],this._buffinfo.Value);
            _loc4_ = ConosrtionTimerManager.Instance.count * 1000;
            if(this._buffinfo && _loc4_ > 0)
            {
               this._tips.tipData = this._tipsTxt.text;
            }
            else
            {
               this._tips.tipData = "你今日累积在线满1小时,请领取奖励";
            }
            this._tips.visible = true;
            LayerManager.Instance.addToLayer(this._tips,LayerManager.GAME_TOP_LAYER);
            _loc5_ = this._btnBg.localToGlobal(new Point(0,0));
            this._tips.x = _loc5_.x - 168;
            this._tips.y = _loc5_.y + 60;
         }
      }
      
      private function __mouseOut(param1:MouseEvent) : void
      {
         if(this._tips)
         {
            this._tips.visible = false;
         }
      }
      
      private function __upTimer(param1:TimeEvents) : void
      {
         var _loc2_:String = TimeManager.Instance.formatTimeToString1(ConosrtionTimerManager.Instance.count * 1000,false);
         var _loc3_:int = ConosrtionTimerManager.Instance.count * 1000;
         this._timerTxt.text = _loc2_;
         if(_loc3_ <= 0)
         {
            this._btnBg.setFrame(2);
            this._timerTxt.visible = false;
            this._timeBg.visible = false;
            TimeManager.removeEventListener(TimeEvents.SECONDS,this.__upTimer);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._btnBg = null;
         this._timeBg = null;
         if(this._tips)
         {
            if(this._tips.parent)
            {
               this._tips.parent.removeChild(this._tips);
               ObjectUtils.disposeObject(this._tips);
            }
         }
         this._tips = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
