package game.view.prop
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   
   public class FightModelPropCell extends BaseCell
   {
       
      
      private var _shortcutKeyShape:DisplayObject;
      
      private var _image:DisplayObject;
      
      private var _shortcutKey:String;
      
      private var _selectedImage:Bitmap;
      
      public function FightModelPropCell(param1:String = null)
      {
         super(ComponentFactory.Instance.creatBitmap("asset.game.prop.ItemBack"));
         this._shortcutKey = param1;
         this.configUI();
         this.addEvent();
      }
      
      private function intTips() : void
      {
         if(this._shortcutKey == "Q")
         {
            tipData = "给对方造成**点伤害";
         }
         else if(this._shortcutKey == "E")
         {
            tipData = "引导模式";
         }
      }
      
      private function configUI() : void
      {
         if(this._shortcutKey == "Q")
         {
            this._image = ComponentFactory.Instance.creatBitmap("asset.game.fightModelPropBar.powAsset");
         }
         else if(this._shortcutKey == "E")
         {
            this._image = ComponentFactory.Instance.creatBitmap("asset.game.fightModelPropBar.leadAsset");
         }
         addChild(this._image);
         if(this._shortcutKey != null)
         {
            this._shortcutKeyShape = ComponentFactory.Instance.creatBitmap("asset.game.prop.ShortcutKey" + this._shortcutKey);
            Bitmap(this._shortcutKeyShape).smoothing = true;
            this._shortcutKeyShape.y = -2;
            addChild(this._shortcutKeyShape);
         }
         this._selectedImage = ComponentFactory.Instance.creatBitmap("asset.game.fightModelPropBar.pointCell");
         this._selectedImage.visible = false;
         addChild(this._selectedImage);
      }
      
      public function setSelected(param1:Boolean) : void
      {
         this._selectedImage.visible = param1;
      }
      
      public function get shortcutKey() : String
      {
         return this._shortcutKey;
      }
      
      public function set shortcutKey(param1:String) : void
      {
         this._shortcutKey = param1;
      }
      
      private function addEvent() : void
      {
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._shortcutKeyShape);
         this._shortcutKeyShape = null;
         ObjectUtils.disposeObject(this._shortcutKey);
         this._shortcutKey = null;
         ObjectUtils.disposeObject(this._selectedImage);
         this._selectedImage = null;
         ObjectUtils.disposeObject(this._image);
         this._image = null;
         super.dispose();
      }
   }
}
