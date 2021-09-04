package ddt.view.bossbox
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.view.tips.GoodTip;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class SmallBoxButton extends Sprite implements Disposeable
   {
      
      public static const showTypeWait:int = 1;
      
      public static const showTypeCountDown:int = 2;
      
      public static const showTypeOpenbox:int = 3;
      
      public static const showTypeHide:int = 4;
      
      public static const HALL_POINT:int = 0;
      
      public static const PVR_ROOMLIST_POINT:int = 1;
      
      public static const PVP_ROOM_POINT:int = 2;
      
      public static const PVE_ROOMLIST_POINT:int = 3;
      
      public static const PVE_ROOM_POINT:int = 4;
      
      public static const HOTSPRING_ROOMLIST_POINT:int = 5;
      
      public static const HOTSPRING_ROOM_POINT:int = 6;
       
      
      private var _closeBox:MovieImage;
      
      private var _openBoxAsset:MovieClip;
      
      private var _openBox:Sprite;
      
      private var _delayText:Sprite;
      
      private var timeText:FilterFrameText;
      
      private var _timeSprite:TimeTip;
      
      private var _pointArray:Vector.<Point>;
      
      private var _boxGoodTip:GoodTip;
      
      public function SmallBoxButton(param1:int)
      {
         super();
         this.init(param1);
         this.initEvent();
      }
      
      private function init(param1:int) : void
      {
         this._getPoint();
         this._delayText = new Sprite();
         this._openBox = new Sprite();
         this._openBox.graphics.beginFill(0,0);
         this._openBox.graphics.drawRect(-22,-2,115,70);
         this._openBox.graphics.endFill();
         this._closeBox = ComponentFactory.Instance.creat("bossbox.closeBox");
         this._openBoxAsset = ComponentFactory.Instance.creat("asset.timeBox.BGRotationAsset");
         this._openBoxAsset.x = -38;
         this._openBoxAsset.y = -40;
         this._openBoxAsset.mouseChildren = false;
         this._openBoxAsset.mouseEnabled = false;
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.timeBox.timeBGAsset");
         this.timeText = ComponentFactory.Instance.creat("bossbox.TimeBoxStyle");
         this._delayText.addChild(_loc2_);
         this._delayText.addChild(this.timeText);
         this._timeSprite = ComponentFactory.Instance.creat("TimeBox.TimeTip");
         this._timeSprite.tipData = LanguageMgr.GetTranslation("tanl.timebox.tipMes");
         this._timeSprite.setView(this._closeBox,this._delayText);
         this._timeSprite.buttonMode = true;
         addChild(this._timeSprite);
         this._openBox.addChild(this._openBoxAsset);
         addChild(this._openBox);
         addChild(this._delayText);
         this._boxGoodTip = new GoodTip();
         this.showType(BossBoxManager.instance.boxButtonShowType);
         this.updateTime(BossBoxManager.instance.delaySumTime);
         x = this._pointArray[param1].x;
         y = this._pointArray[param1].y;
      }
      
      private function _getPoint() : void
      {
         var _loc2_:Point = null;
         this._pointArray = new Vector.<Point>();
         var _loc1_:int = 0;
         while(_loc1_ < 7)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("smallBoxbutton.point" + _loc1_);
            this._pointArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         this._openBox.buttonMode = true;
         this._openBox.addEventListener(MouseEvent.CLICK,this._click);
         this._openBox.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         this._openBox.addEventListener(MouseEvent.ROLL_OUT,this.__mouseOut);
         this._timeSprite.addEventListener(MouseEvent.CLICK,this._click);
         BossBoxManager.instance.addEventListener(TimeBoxEvent.UPDATESMALLBOXBUTTONSTATE,this._updateSmallBoxState);
         BossBoxManager.instance.addEventListener(TimeBoxEvent.UPDATETIMECOUNT,this._updateTimeCount);
      }
      
      private function __mouseOver(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(this._boxGoodTip)
         {
            this._boxGoodTip.visible = true;
            LayerManager.Instance.addToLayer(this._boxGoodTip,LayerManager.GAME_TOP_LAYER);
            _loc2_ = this._openBox.localToGlobal(new Point(0,0));
            this._boxGoodTip.x = 114;
            this._boxGoodTip.y = 200;
         }
      }
      
      private function __mouseOut(param1:MouseEvent) : void
      {
         if(this._boxGoodTip)
         {
            this._boxGoodTip.visible = false;
         }
      }
      
      public function updateTime(param1:int) : void
      {
         var _loc2_:int = param1;
         this.timeText.text = TimeManager.Instance.formatTimeToString1(_loc2_ * 1000);
      }
      
      public function showType(param1:int) : void
      {
         var _loc2_:GoodTipInfo = new GoodTipInfo();
         var _loc3_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(BossBoxManager.instance.getBoxTemplateIDById());
         _loc2_.itemInfo = _loc3_;
         this._boxGoodTip.tipData = _loc2_;
         switch(param1)
         {
            case SmallBoxButton.showTypeWait:
               this._openBox.visible = true;
               this._openBoxAsset.gotoAndStop(1);
               this._timeSprite.delayText.visible = true;
               this._boxGoodTip.visible = false;
               break;
            case SmallBoxButton.showTypeCountDown:
               this._openBox.visible = true;
               this._timeSprite.delayText.visible = true;
               this._boxGoodTip.visible = false;
               break;
            case SmallBoxButton.showTypeOpenbox:
               this._openBox.visible = true;
               this._openBoxAsset.gotoAndPlay(1);
               this._timeSprite.delayText.visible = false;
               this._boxGoodTip.visible = false;
               break;
            case SmallBoxButton.showTypeHide:
               this.visible = true;
               this._openBox.visible = false;
               this._timeSprite.delayText.visible = false;
               this._boxGoodTip.visible = false;
         }
      }
      
      private function _click(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(BossBoxManager.instance.delaySumTime != 0)
         {
            return MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.AwardTipsI"));
         }
         SocketManager.Instance.out.sendGetTimeBox(1);
         this._boxGoodTip.visible = false;
      }
      
      private function _updateSmallBoxState(param1:TimeBoxEvent) : void
      {
         this.showType(param1.boxButtonShowType);
      }
      
      private function _updateTimeCount(param1:TimeBoxEvent) : void
      {
         this.updateTime(param1.delaySumTime);
      }
      
      private function removeEvent() : void
      {
         this._openBox.removeEventListener(MouseEvent.CLICK,this._click);
         this._openBox.removeEventListener(MouseEvent.CLICK,this._click);
         this._openBox.removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         this._timeSprite.removeEventListener(MouseEvent.CLICK,this._click);
         BossBoxManager.instance.removeEventListener(TimeBoxEvent.UPDATESMALLBOXBUTTONSTATE,this._updateSmallBoxState);
         BossBoxManager.instance.removeEventListener(TimeBoxEvent.UPDATETIMECOUNT,this._updateTimeCount);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._closeBox)
         {
            ObjectUtils.disposeObject(this._closeBox);
         }
         this._closeBox = null;
         if(this._openBoxAsset)
         {
            ObjectUtils.disposeObject(this._openBoxAsset);
         }
         this._openBoxAsset = null;
         if(this._openBox)
         {
            ObjectUtils.disposeObject(this._openBox);
         }
         this._openBox = null;
         if(this._delayText)
         {
            ObjectUtils.disposeObject(this._delayText);
         }
         this._delayText = null;
         if(this.timeText)
         {
            ObjectUtils.disposeObject(this.timeText);
         }
         this.timeText = null;
         if(this._timeSprite)
         {
            ObjectUtils.disposeObject(this._timeSprite);
         }
         if(this._boxGoodTip)
         {
            ObjectUtils.disposeObject(this._boxGoodTip);
         }
         this._timeSprite = null;
         this._pointArray = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
