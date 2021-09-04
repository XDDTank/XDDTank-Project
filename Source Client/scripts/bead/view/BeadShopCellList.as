package bead.view
{
   import bead.BeadManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class BeadShopCellList extends Sprite implements Disposeable
   {
      
      public static const TotalCount:int = 6;
       
      
      private var _beadCellList:Vector.<BeadShopCell>;
      
      private var _beadScoreShopItemList:Array;
      
      private var _curPage:int;
      
      public function BeadShopCellList()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc2_:BeadShopCell = null;
         this._beadCellList = new Vector.<BeadShopCell>();
         var _loc1_:int = 0;
         while(_loc1_ < TotalCount)
         {
            _loc2_ = new BeadShopCell();
            _loc2_.x = _loc1_ % 2 * (5 + _loc2_.width);
            _loc2_.y = int(_loc1_ / 2) * (5 + _loc2_.height);
            addChild(_loc2_);
            this._beadCellList.push(_loc2_);
            _loc1_++;
         }
         this._beadScoreShopItemList = BeadManager.instance.scoreShopItemList;
      }
      
      public function show(param1:int) : void
      {
         if(this._curPage == param1)
         {
            return;
         }
         this._curPage = param1;
         var _loc2_:int = (this._curPage - 1) * TotalCount;
         var _loc3_:int = this._curPage * TotalCount - 1;
         var _loc4_:int = _loc2_;
         while(_loc4_ <= _loc3_)
         {
            this._beadCellList[_loc4_ - _loc2_].show(this._beadScoreShopItemList[_loc4_]);
            _loc4_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:BeadShopCell = null;
         for each(_loc1_ in this._beadCellList)
         {
            if(_loc1_)
            {
               ObjectUtils.disposeObject(_loc1_);
            }
         }
         this._beadCellList = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
