package exitPrompt
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.events.MouseEvent;
   
   public class ExitButtonItem extends Component
   {
       
      
      private var _bt:ScaleFrameImage;
      
      private var _fontBg:ScaleFrameImage;
      
      public var fontBgBgUrl:String;
      
      public var coord:String;
      
      public function ExitButtonItem()
      {
         super();
         mouseChildren = false;
         buttonMode = true;
         this.initEvent();
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         var _loc1_:Array = this.coord.split(/,/g);
         if(!this._bt)
         {
            this._bt = ComponentFactory.Instance.creat("ExitPromptFrame.MissionBt");
         }
         this._bt.setFrame(2);
         if(!this._fontBg)
         {
            this._fontBg = ComponentFactory.Instance.creat(this.fontBgBgUrl);
         }
         addChild(this._bt);
         addChild(this._fontBg);
         this._fontBg.x = _loc1_[0];
         this._fontBg.y = _loc1_[1];
         height = this._bt.height;
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
      }
      
      private function __mouseOverHandler(param1:MouseEvent) : void
      {
         this._bt.setFrame(1);
         this._fontBg.setFrame(1);
      }
      
      private function __mouseOutHandler(param1:MouseEvent) : void
      {
         this._bt.setFrame(2);
         this._fontBg.setFrame(2);
      }
      
      public function setFrame(param1:int) : void
      {
         this._bt.setFrame(param1);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         ObjectUtils.disposeObject(this._bt);
         ObjectUtils.disposeObject(this._fontBg);
         this._bt = null;
         this._fontBg = null;
      }
   }
}
