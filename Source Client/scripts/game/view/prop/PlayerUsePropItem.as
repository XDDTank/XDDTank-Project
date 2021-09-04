package game.view.prop
{
   import bagAndInfo.bag.ItemCellView;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import game.model.Player;
   import game.view.playerThumbnail.PlayerThumbItem;
   
   public class PlayerUsePropItem extends Sprite implements Disposeable
   {
       
      
      private var _info:Player;
      
      private var _headFigure:PlayerThumbItem;
      
      private var _itemCellList:Vector.<ItemCellView>;
      
      private var _width:int;
      
      private var _timeLine:TimelineMax;
      
      public function PlayerUsePropItem(param1:Player)
      {
         super();
         this._info = param1;
         this.init();
      }
      
      protected function init() : void
      {
         this._headFigure = ComponentFactory.Instance.creat("game.view.prop.PlayerUsePropItem.headFigure",[this._info]);
         if(this._info.isLiving)
         {
            this._headFigure.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         addChild(this._headFigure);
         this._width += 5;
         this._itemCellList = new Vector.<ItemCellView>();
         this._timeLine = new TimelineMax();
      }
      
      public function start() : void
      {
         this._headFigure.alpha = 0;
         this._headFigure.x = this._headFigure.width;
         this._width = this._headFigure.width + 5;
         var _loc1_:TweenMax = TweenMax.to(this._headFigure,0.25,{
            "x":0,
            "alpha":1,
            "glowFilter":{
               "color":16777164,
               "blurX":50,
               "blurY":50
            },
            "colorMatrixFilter":{"brightness":2}
         });
         var _loc2_:TweenMax = TweenMax.to(this._headFigure,0.25,{
            "x":0,
            "alpha":1,
            "glowFilter":{
               "color":16777164,
               "blurX":0,
               "blurY":0
            },
            "colorMatrixFilter":{"brightness":1}
         });
         this._timeLine.append(_loc1_);
         this._timeLine.append(_loc2_);
         this._timeLine.play();
      }
      
      public function addProp(param1:DisplayObject) : void
      {
         var _loc2_:ItemCellView = null;
         _loc2_ = new ItemCellView(0,param1);
         _loc2_.alpha = 0;
         _loc2_.x = this._width + _loc2_.width;
         addChild(_loc2_);
         this._itemCellList.push(_loc2_);
         this._timeLine.append(TweenMax.to(_loc2_,0.1,{
            "x":this._width,
            "alpha":1,
            "colorMatrixFilter":{"brightness":2.4}
         }));
         this._timeLine.append(TweenMax.to(_loc2_,0.1,{"colorMatrixFilter":{"brightness":1}}));
         this._timeLine.play();
         this._width = this._width + _loc2_.width + 5;
      }
      
      public function dispose() : void
      {
         this._timeLine.kill();
         this._timeLine = null;
         ObjectUtils.disposeObject(this._headFigure);
         this._headFigure = null;
         while(this._itemCellList.length > 0)
         {
            ObjectUtils.disposeObject(this._itemCellList.shift());
         }
         this._itemCellList = null;
         this._info = null;
      }
   }
}
