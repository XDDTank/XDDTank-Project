package game.view.prop
{
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.PropInfo;
   import ddt.manager.BitmapManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public class WeaponPropCell extends PropCell
   {
       
      
      private var _bg:Bitmap;
      
      private var _countField:FilterFrameText;
      
      private var _bitmap:Bitmap;
      
      public function WeaponPropCell(param1:String, param2:int)
      {
         super(param1,param2);
      }
      
      private static function creatDeputyWeaponIcon(param1:int) : Bitmap
      {
         switch(param1)
         {
            case EquipType.Angle:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop29Asset");
            case EquipType.TrueAngle:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop30Asset");
            case EquipType.ExllenceAngle:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop35Asset");
            case EquipType.FlyAngle:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop36Asset");
            case EquipType.TrueShield:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop31Asset");
            case EquipType.ExcellentShield:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop32Asset");
            case EquipType.FlyAngleOne:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop40Asset");
            case EquipType.WishKingBlessing:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop41Asset");
            case EquipType.PYX1:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop50Asset");
            default:
               return null;
         }
      }
      
      override public function setPossiton(param1:int, param2:int) : void
      {
         super.setPossiton(param1,param2);
         this.x = _x;
         this.y = _y;
      }
      
      override protected function drawLayer() : void
      {
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._countField = ComponentFactory.Instance.creatComponentByStylename("game.PropCell.CountField");
         addChild(this._countField);
      }
      
      public function setCount(param1:int) : void
      {
         this._countField.text = param1.toString();
         this._countField.x = _back.width - this._countField.width;
         this._countField.y = _back.height - this._countField.height;
      }
      
      override public function set info(param1:PropInfo) : void
      {
         var asset:DisplayObject = null;
         var val:PropInfo = param1;
         ShowTipManager.Instance.removeTip(this);
         _info = val;
         asset = _asset;
         if(_info != null)
         {
            if(_info.Template.CategoryID != EquipType.HOLYGRAIL && _info.Template.CategoryID != EquipType.TEMP_OFFHAND || _info.Template.TemplateID == 17200)
            {
               try
               {
                  this._bitmap = ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop" + _info.Template.Pic + "Asset");
                  this.setBitmap();
               }
               catch(err:Error)
               {
                  BitmapManager.LoadPic(loadPicComplete,_info.Template);
               }
            }
            else
            {
               this._bitmap = creatDeputyWeaponIcon(_info.TemplateID);
            }
            _tipInfo.info = _info.Template;
            _tipInfo.shortcutKey = _shortcutKey;
            ShowTipManager.Instance.addTip(this);
            buttonMode = true;
         }
         else
         {
            buttonMode = false;
         }
         if(asset != null)
         {
            ObjectUtils.disposeObject(asset);
         }
         this._countField.visible = _info != null || _asset != null;
      }
      
      private function loadPicComplete(param1:LoaderEvent) : void
      {
         if(param1.loader.isSuccess)
         {
            this._bitmap = Bitmap(param1.loader.content);
            this.setBitmap();
         }
      }
      
      private function setBitmap() : void
      {
         if(this._bitmap && _fore)
         {
            this._bitmap.smoothing = true;
            this._bitmap.x = this._bitmap.y = 3;
            this._bitmap.width = this._bitmap.height = 32;
            addChildAt(this._bitmap,getChildIndex(_fore));
         }
         _asset = this._bitmap;
      }
      
      override public function useProp() : void
      {
         if(_info || _asset)
         {
            dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._countField);
         this._countField = null;
         ObjectUtils.disposeObject(this._bitmap);
         this._bitmap = null;
         ShowTipManager.Instance.removeTip(this);
         super.dispose();
      }
   }
}
