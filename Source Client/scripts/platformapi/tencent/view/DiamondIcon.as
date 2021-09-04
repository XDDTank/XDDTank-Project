package platformapi.tencent.view
{
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import platformapi.tencent.DiamondManager;
   import platformapi.tencent.DiamondType;
   import platformapi.tencent.interfaces.IDiamondIcon;
   
   public class DiamondIcon extends Sprite implements IDiamondIcon
   {
       
      
      private var _type:int;
      
      private var _icon:IDiamondIcon;
      
      private var _level:int;
      
      private var _isDisposed:Boolean;
      
      private var _width:int;
      
      private var _height:int;
      
      public function DiamondIcon(param1:int, param2:int = 30, param3:int = 26)
      {
         super();
         this._type = param1;
         this._width = param2;
         this._height = param3;
         DiamondManager.instance.addEventListener(Event.COMPLETE,this.__init);
         DiamondManager.instance.loadUIModule();
      }
      
      private function __init(param1:Event = null) : void
      {
         var _loc2_:DisplayObject = null;
         DiamondManager.instance.removeEventListener(Event.COMPLETE,this.__init);
         if(this._isDisposed)
         {
            return;
         }
         if(this._type == 0)
         {
            switch(DiamondManager.instance.model.pfdata.pfType)
            {
               case DiamondType.YELLOW_DIAMOND:
                  this._icon = new YellowDiamondIcon();
                  break;
               case DiamondType.BLUE_DIAMOND:
                  this._icon = new BlueDiamondIcon();
                  break;
               case DiamondType.MEMBER_DIAMOND:
                  this._icon = new MemberDiamondIcon();
            }
         }
         else
         {
            this._icon = new BunIcon();
         }
         if(this._icon)
         {
            _loc2_ = this._icon as DisplayObject;
            _loc2_.x = (this._width - _loc2_.width) / 2;
            _loc2_.y = (this._height - _loc2_.height) / 2;
            addChild(DisplayObject(this._icon));
         }
         this.level = this._level;
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
         if(this._icon)
         {
            this._icon.level = this._level;
         }
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function dispose() : void
      {
         DiamondManager.instance.removeEventListener(Event.COMPLETE,this.__init);
         this._isDisposed = true;
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
