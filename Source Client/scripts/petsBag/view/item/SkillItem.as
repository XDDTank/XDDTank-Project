package petsBag.view.item
{
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.display.BitmapLoaderProxy;
   import ddt.manager.PathManager;
   import ddt.view.tips.ToolPropInfo;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import pet.date.PetSkillInfo;
   
   public class SkillItem extends Component
   {
      
      public static const ZOOMVALUE:Number = 0.5;
       
      
      protected var _info:PetSkillInfo;
      
      protected var _skillIcon:DisplayObject;
      
      private var _iconPos:Point;
      
      protected var _tipInfo:ToolPropInfo;
      
      public var DoubleClickEnabled:Boolean = false;
      
      private var _skillID:int = -1;
      
      public function SkillItem()
      {
         super();
         this._iconPos = new Point();
         this.initView();
         this.initEvent();
      }
      
      override public function get tipStyle() : String
      {
         return "ddt.view.tips.PetSkillCellTip";
      }
      
      override public function get tipData() : Object
      {
         return this._info;
      }
      
      public function get skillID() : int
      {
         return this._skillID;
      }
      
      public function get iconPos() : Point
      {
         return this._iconPos;
      }
      
      public function set iconPos(param1:Point) : void
      {
         this._iconPos = param1;
         this.updateSize();
      }
      
      protected function initView() : void
      {
         tipDirctions = "5,2,7,1,6,4";
         tipGapV = tipGapH = 20;
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function updateSize() : void
      {
         if(this._skillIcon)
         {
            this._skillIcon.x = (width - 38) / 2;
            this._skillIcon.y = (height - 38) / 2;
         }
      }
      
      public function get info() : PetSkillInfo
      {
         return this._info;
      }
      
      public function set info(param1:PetSkillInfo) : void
      {
         if(this._info && param1 && this._info.ID == param1.ID)
         {
            return;
         }
         this._info = param1;
         ShowTipManager.Instance.removeTip(this);
         ObjectUtils.disposeObject(this._skillIcon);
         this._skillIcon = null;
         _tipData = null;
         if(this._info && this._info.ID > 0)
         {
            this._skillIcon = new BitmapLoaderProxy(PathManager.solveSkillPicUrl(this._info.Pic),new Rectangle(0,0,44,44));
            addChild(this._skillIcon);
            this.updateSize();
            ShowTipManager.Instance.addTip(this);
         }
      }
      
      protected function creatDragImg() : DisplayObject
      {
         var _loc1_:Bitmap = new Bitmap(new BitmapData(this._skillIcon.width / this._skillIcon.scaleX,this._skillIcon.height / this._skillIcon.scaleY,true,4294967295));
         _loc1_.bitmapData.draw(this._skillIcon);
         _loc1_.scaleX = 0.75;
         _loc1_.scaleY = 0.75;
         return _loc1_;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._skillIcon);
         this._skillIcon = null;
         this._info = null;
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}
