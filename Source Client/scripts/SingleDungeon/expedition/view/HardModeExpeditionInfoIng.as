package SingleDungeon.expedition.view
{
   import SingleDungeon.expedition.ExpeditionInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class HardModeExpeditionInfoIng extends Sprite implements Disposeable
   {
       
      
      private var _currentTimesText:FilterFrameText;
      
      private var _remainTimeText:FilterFrameText;
      
      private var _finishTime:Number;
      
      private var _fontBmp:Bitmap;
      
      private var _timerIsRunning:Boolean;
      
      private var _expeditionInfo:ExpeditionInfo;
      
      public function HardModeExpeditionInfoIng()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function update() : void
      {
         this._currentTimesText.text = String(PlayerManager.Instance.Self.expeditionNumAll - PlayerManager.Instance.Self.expeditionNumCur + 1);
      }
      
      public function updateRemainTxt(param1:String) : void
      {
         this._remainTimeText.text = param1;
      }
      
      private function initView() : void
      {
         this._fontBmp = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.hardMode.ingInfo");
         addChild(this._fontBmp);
         this._currentTimesText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.ExpeditionInfoIng.hardModeNowTimes.text");
         addChild(this._currentTimesText);
         this._remainTimeText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.ExpeditionInfoIng.hardModeRemainTime.text");
         addChild(this._remainTimeText);
      }
      
      private function removeView() : void
      {
         ObjectUtils.disposeObject(this._remainTimeText);
         this._remainTimeText = null;
         ObjectUtils.disposeObject(this._currentTimesText);
         this._currentTimesText = null;
         ObjectUtils.disposeObject(this._remainTimeText);
         this._remainTimeText = null;
         ObjectUtils.disposeObject(this._fontBmp);
         this._fontBmp = null;
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
      }
   }
}
