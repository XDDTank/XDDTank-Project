package liveness
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.view.tips.OneLineTipUseHtmlText;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class StarContent extends Sprite implements Disposeable
   {
       
      
      private var _type:uint;
      
      private var _index:uint;
      
      private var _enable:Boolean;
      
      private var _starObj:DisplayObject;
      
      private var _starTip:OneLineTipUseHtmlText;
      
      public function StarContent(param1:uint)
      {
         super();
         this._index = param1;
         this._type = LivenessAwardManager.Instance.model.statusList[this._index];
         this.createBmp();
         this.addEvent();
         addChild(this._starObj);
      }
      
      private function createBmp() : void
      {
         this.enable = false;
         switch(this._type)
         {
            case LivenessModel.NOT_THE_TIME:
               this._starObj = ComponentFactory.Instance.creatBitmap("asset.liveness.starNotSign");
               break;
            case LivenessModel.DAY_PASS:
               this._starObj = ComponentFactory.Instance.creatBitmap("asset.liveness.starNormal");
               this._starObj.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               break;
            case LivenessModel.NOT_GET_AWARD:
               this._starObj = ComponentFactory.Instance.creat("asset.liveness.starAppear");
               this._starObj.addEventListener(Event.COMPLETE,this.__starAppear);
               (this._starObj as MovieClip).gotoAndPlay(2);
               break;
            case LivenessModel.HAS_GET_AWARD:
               this._starObj = ComponentFactory.Instance.creatBitmap("asset.liveness.starNormal");
         }
      }
      
      private function __starAppear(param1:Event) : void
      {
         this.enable = true;
      }
      
      private function addEvent() : void
      {
         this.addEventListener(MouseEvent.ROLL_OVER,this.__rollOver);
         this.addEventListener(MouseEvent.ROLL_OUT,this.__rollOut);
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener(MouseEvent.ROLL_OVER,this.__rollOver);
         this.removeEventListener(MouseEvent.ROLL_OUT,this.__rollOut);
      }
      
      private function __rollOver(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(this._starTip)
         {
            this._starTip.visible = true;
            LayerManager.Instance.addToLayer(this._starTip,LayerManager.GAME_TOP_LAYER);
            _loc2_ = this.localToGlobal(new Point(0,0));
            this._starTip.x = _loc2_.x + this.width;
            this._starTip.y = _loc2_.y + this.height;
         }
      }
      
      private function __rollOut(param1:MouseEvent) : void
      {
         if(this._starTip)
         {
            this._starTip.visible = false;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._starObj);
         this._starObj = null;
         ObjectUtils.disposeObject(this._starTip);
         this._starTip = null;
      }
      
      public function set enable(param1:Boolean) : void
      {
         this._enable = param1;
         if(param1)
         {
            this.buttonMode = true;
            this.useHandCursor = true;
         }
         else
         {
            this.buttonMode = false;
            this.useHandCursor = false;
         }
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
      
      public function get index() : uint
      {
         if(this._index == 6)
         {
            return 0;
         }
         if(this._index == 7)
         {
            return 7;
         }
         return this._index + 1;
      }
      
      public function reflashStar() : void
      {
         this._type = LivenessAwardManager.Instance.model.statusList[this._index];
         removeChild(this._starObj);
         if(this._starObj.hasEventListener(Event.COMPLETE))
         {
            this._starObj.removeEventListener(Event.COMPLETE,this.__starAppear);
         }
         this._starObj = null;
         this.createBmp();
         addChild(this._starObj);
      }
      
      public function set type(param1:uint) : void
      {
         this._type = param1;
      }
   }
}
