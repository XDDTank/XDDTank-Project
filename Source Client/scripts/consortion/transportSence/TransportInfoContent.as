package consortion.transportSence
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class TransportInfoContent extends Sprite implements Disposeable
   {
       
      
      private var _content:FilterFrameText;
      
      private var _isMyInfo:Boolean;
      
      public function TransportInfoContent(param1:String, param2:String, param3:int, param4:int)
      {
         super();
         this._content = ComponentFactory.Instance.creatComponentByStylename("TransportInfoPanel.infoContentTextStyle");
         this._content.htmlText = LanguageMgr.GetTranslation("consortion.ConsortionTransport.hijackInfoContent.txt",param1,param2,param3,param4);
         addChild(this._content);
      }
      
      override public function get width() : Number
      {
         return this._content.textWidth;
      }
      
      override public function get height() : Number
      {
         return this._content.textHeight + 4;
      }
      
      public function dispose() : void
      {
      }
      
      public function dispose2() : void
      {
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         this._content = null;
      }
      
      public function get isMyInfo() : Boolean
      {
         return this._isMyInfo;
      }
      
      public function set isMyInfo(param1:Boolean) : void
      {
         this._isMyInfo = param1;
      }
   }
}
