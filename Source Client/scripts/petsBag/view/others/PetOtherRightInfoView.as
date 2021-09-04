package petsBag.view.others
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import pet.date.PetInfo;
   import petsBag.view.PetInfoView;
   import petsBag.view.item.PetBigItem;
   
   public class PetOtherRightInfoView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _infoView:PetInfoView;
      
      private var _pet:PetBigItem;
      
      private var _info:PetInfo;
      
      public function PetOtherRightInfoView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("petsBag.view.other.petInfoView.bg");
         addChild(this._bg);
         this._infoView = ComponentFactory.Instance.creat("petsBag.view.OtherpetInfoView");
         this._infoView.setVisible(false);
         addChild(this._infoView);
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function get info() : PetInfo
      {
         return this._info;
      }
      
      public function set info(param1:PetInfo) : void
      {
         this._info = param1;
         this.update();
      }
      
      public function update() : void
      {
         if(this._info)
         {
            this._infoView.info = this._info;
         }
         else
         {
            this._infoView.info = null;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         this._infoView.dispose();
         this._info = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
