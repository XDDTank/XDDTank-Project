package LimitAward
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConosrtionTimerManager;
   import ddt.data.BuffInfo;
   import ddt.data.EquipType;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.events.MouseEvent;
   
   public class ConsortionAwardFrame extends Frame
   {
       
      
      private var _itemBg:Scale9CornerImage;
      
      private var _goodItemBg:Scale9CornerImage;
      
      private var _cellBg:Scale9CornerImage;
      
      private var _itemCell:BaseCell;
      
      private var _decTxt:FilterFrameText;
      
      private var _itemNameTxt:FilterFrameText;
      
      private var _buffinfo:BuffInfo;
      
      private var _receiveBtn:BaseButton;
      
      public function ConsortionAwardFrame()
      {
         super();
         this.initView();
         this.initEvent();
         escEnable = true;
      }
      
      public static function transformFormatDateTime(param1:Number) : String
      {
         var _loc2_:Date = new Date(param1);
         _loc2_.seconds = _loc2_.minutes = _loc2_.hours = 0;
         var _loc3_:Number = _loc2_.time + param1;
         var _loc4_:String = String(new Date(_loc3_));
         return _loc4_.split(" ")[3];
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.timeBox.awardsInfo");
         this._buffinfo = PlayerManager.Instance.Self.buffInfo[BuffInfo.GET_ONLINE_REWARS];
         this._itemBg = ComponentFactory.Instance.creatComponentByStylename("Consortion.GetAwardsItemBG");
         this._goodItemBg = ComponentFactory.Instance.creatComponentByStylename("Consortion.GetAwardsGoodBG");
         this._cellBg = ComponentFactory.Instance.creatComponentByStylename("Consortion.GetAwardsItemCellBG");
         this._itemCell = new BaseCell(this._cellBg,ItemManager.Instance.getTemplateById(EquipType.GOLD_BOX));
         this._itemCell.x = 102;
         this._itemCell.y = 117;
         this._itemCell.tipGapV = 10;
         this._itemCell.setContentSize(40,40);
         var _loc1_:String = TimeManager.Instance.formatTimeToString1(ConosrtionTimerManager.Instance.count * 1000,false);
         var _loc2_:int = ConosrtionTimerManager.Instance.count * 1000;
         var _loc3_:Array = _loc1_.split(":");
         this._decTxt = ComponentFactory.Instance.creatComponentByStylename("ConsortionAwardFrame.decTxt");
         this._receiveBtn = ComponentFactory.Instance.creatComponentByStylename("ConsortionAwardFrame.btn");
         if(_loc2_ == 0)
         {
            this._decTxt.text = "你今日累积在线满1小时，可获得以下奖励";
            this._receiveBtn.enable = true;
         }
         else
         {
            this._decTxt.text = LanguageMgr.GetTranslation("ddt.consortionAwardFrame.dec",_loc3_[0],_loc3_[1]);
            this._receiveBtn.enable = false;
         }
         this._itemNameTxt = ComponentFactory.Instance.creatComponentByStylename("ConsortionAwardFrame.itemNameTxt");
         this._itemNameTxt.text = this._buffinfo.Value.toString() + "个金币箱";
         addToContent(this._itemBg);
         addToContent(this._goodItemBg);
         addToContent(this._cellBg);
         addToContent(this._itemCell);
         addToContent(this._decTxt);
         addToContent(this._itemNameTxt);
         addToContent(this._receiveBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
         this._receiveBtn.addEventListener(MouseEvent.CLICK,this._mouseClick);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         this._receiveBtn.removeEventListener(MouseEvent.CLICK,this._mouseClick);
      }
      
      private function _mouseClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendOnlineReawd();
         this.dispose();
      }
      
      private function __response(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._itemBg = null;
         this._goodItemBg = null;
         this._cellBg = null;
         this._itemCell = null;
         this._itemNameTxt = null;
         this._decTxt = null;
         this._buffinfo = null;
         this._receiveBtn = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
