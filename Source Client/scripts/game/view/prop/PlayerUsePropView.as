package game.view.prop
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.LivingEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.view.PropItemView;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import game.model.Player;
   import road7th.data.DictionaryData;
   
   public class PlayerUsePropView extends Component
   {
       
      
      private var _usePropItemDic:Dictionary;
      
      private var _timeID:uint;
      
      private var _playerList:DictionaryData;
      
      public function PlayerUsePropView(param1:DictionaryData)
      {
         super();
         this._playerList = param1;
         this._usePropItemDic = new Dictionary();
         mouseEnabled = false;
         mouseChildren = false;
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in this._playerList)
         {
            this._playerList[_loc1_].addEventListener(LivingEvent.ADD_STATE,this.__addingState,false,0,true);
         }
      }
      
      private function __addingState(param1:LivingEvent) : void
      {
         var _loc3_:Bitmap = null;
         var _loc2_:Player = param1.target as Player;
         if(!_loc2_ || !_loc2_.isLiving)
         {
            return;
         }
         if(param1.value == -1)
         {
            _loc3_ = ComponentFactory.Instance.creatBitmap("game.crazyTank.view.specialKillAsset");
            _loc3_.width = 40;
            _loc3_.height = 40;
            this.addItem(param1.target as Player,_loc3_);
         }
      }
      
      public function useItem(param1:Player, param2:ItemTemplateInfo) : void
      {
         var _loc3_:EquipmentTemplateInfo = null;
         var _loc4_:DisplayObject = null;
         if(param1)
         {
            _loc3_ = ItemManager.Instance.getEquipTemplateById(param2.TemplateID);
            if(!_loc3_ || _loc3_.TemplateType != EquipType.HOLYGRAIL)
            {
               this.addItem(param1,PropItemView.createView(param2.Pic,40,40));
            }
            else
            {
               _loc4_ = PlayerManager.Instance.getDeputyWeaponIcon(param2,1);
               this.addItem(param1,_loc4_);
            }
         }
      }
      
      private function addItem(param1:Player, param2:DisplayObject) : void
      {
         var _loc3_:PlayerUsePropItem = null;
         if(!this._usePropItemDic[param1])
         {
            _loc3_ = new PlayerUsePropItem(param1);
            this._usePropItemDic[param1] = _loc3_;
            _loc3_.y = _height;
            _height += 50;
            addChild(this._usePropItemDic[param1]);
            _loc3_.start();
         }
         this._usePropItemDic[param1].addProp(param2);
      }
      
      public function hide() : void
      {
         var _loc1_:PlayerUsePropItem = null;
         for each(_loc1_ in this._usePropItemDic)
         {
            TweenLite.to(_loc1_,0.5,{
               "y":_loc1_.y - 50,
               "alpha":0
            });
         }
         this._timeID = setTimeout(this.dispose,1000);
      }
      
      public function clear() : void
      {
         var _loc1_:* = null;
         _height = 0;
         clearTimeout(this._timeID);
         for(_loc1_ in this._usePropItemDic)
         {
            TweenLite.killTweensOf(this._usePropItemDic[_loc1_]);
            ObjectUtils.disposeObject(this._usePropItemDic[_loc1_]);
            delete this._usePropItemDic[_loc1_];
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.clear();
         clearTimeout(this._timeID);
      }
   }
}
