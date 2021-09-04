package quest
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.IconButton;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class ClientDownloadFrame extends Frame
   {
       
      
      private var _descript:FilterFrameText;
      
      private var _itemCell1:BaseCell;
      
      private var _itemCell2:BaseCell;
      
      private var _itemCell3:BaseCell;
      
      private var _cellBg1:Scale9CornerImage;
      
      private var _cellBg2:Scale9CornerImage;
      
      private var _cellBg3:Scale9CornerImage;
      
      private var _itemBg:Scale9CornerImage;
      
      private var _goodItemBg1:Scale9CornerImage;
      
      private var _goodItemBg2:Scale9CornerImage;
      
      private var _goodItemBg3:Scale9CornerImage;
      
      private var _downLoadBtn:IconButton;
      
      private var _awardName1:FilterFrameText;
      
      private var _awardName2:FilterFrameText;
      
      private var _awardName3:FilterFrameText;
      
      public function ClientDownloadFrame()
      {
         super();
         escEnable = true;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:QuestInfo = null;
         titleText = LanguageMgr.GetTranslation("ddt.downloadClient.title.txt");
         this._descript = ComponentFactory.Instance.creatComponentByStylename("task.downloadClient.text");
         this._descript.text = LanguageMgr.GetTranslation("ddt.downloadClient.descript.txt");
         this._itemBg = ComponentFactory.Instance.creatComponentByStylename("task.downloadClient.awardsItemBG");
         this._goodItemBg1 = ComponentFactory.Instance.creatComponentByStylename("task.downloadClient.awardsGoodBG");
         this._goodItemBg2 = ComponentFactory.Instance.creatComponentByStylename("task.downloadClient.awardsGoodBG2");
         this._goodItemBg3 = ComponentFactory.Instance.creatComponentByStylename("task.downloadClient.awardsGoodBG3");
         this._cellBg1 = ComponentFactory.Instance.creatComponentByStylename("task.downloadClient.awardsItemCellBG");
         this._cellBg2 = ComponentFactory.Instance.creatComponentByStylename("task.downloadClient.awardsItemCellBG2");
         this._cellBg3 = ComponentFactory.Instance.creatComponentByStylename("task.downloadClient.awardsItemCellBG3");
         this._awardName1 = ComponentFactory.Instance.creatComponentByStylename("task.downloadClient.awardsName1");
         this._awardName2 = ComponentFactory.Instance.creatComponentByStylename("task.downloadClient.awardsName2");
         this._awardName3 = ComponentFactory.Instance.creatComponentByStylename("task.downloadClient.awardsName3");
         _loc1_ = new InventoryItemInfo();
         _loc2_ = TaskManager.instance.getQuestByID(500);
         _loc1_.TemplateID = _loc2_.RewardItemID;
         ItemManager.fill(_loc1_);
         this._itemCell1 = new BaseCell(this._cellBg1,_loc1_);
         this._itemCell1.x = 15;
         this._itemCell1.y = 75;
         this._itemCell1.PicPos = new Point(0,0);
         this._itemCell2 = new BaseCell(this._cellBg2,ItemManager.Instance.getTemplateById(EquipType.GOLD));
         this._itemCell2.x = 15;
         this._itemCell2.y = 148;
         this._itemCell2.PicPos = new Point(0,0);
         this._itemCell3 = new BaseCell(this._cellBg3,ItemManager.Instance.getTemplateById(EquipType.BIND_MONEY));
         this._itemCell3.x = 195;
         this._itemCell3.y = 75;
         this._itemCell3.PicPos = new Point(0,0);
         this._downLoadBtn = ComponentFactory.Instance.creatComponentByStylename("task.downloadClient.downloadBtn");
         this._awardName1.text = _loc1_.Name;
         this._awardName2.text = _loc2_.RewardGold + LanguageMgr.GetTranslation("gold");
         this._awardName3.text = _loc2_.RewardBindMoney + LanguageMgr.GetTranslation("gift");
         addToContent(this._itemBg);
         addToContent(this._descript);
         addToContent(this._goodItemBg1);
         addToContent(this._goodItemBg2);
         addToContent(this._goodItemBg3);
         addToContent(this._itemCell1);
         addToContent(this._itemCell2);
         addToContent(this._itemCell3);
         addToContent(this._downLoadBtn);
         addToContent(this._awardName1);
         addToContent(this._awardName2);
         addToContent(this._awardName3);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._downLoadBtn.addEventListener(MouseEvent.CLICK,this.__beginToDownload);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._downLoadBtn.removeEventListener(MouseEvent.CLICK,this.__beginToDownload);
      }
      
      private function __beginToDownload(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         navigateToURL(new URLRequest(PathManager.solveClientDownloadPath()));
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            dispatchEvent(new Event(Event.COMPLETE));
            this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._descript);
         this._descript = null;
         ObjectUtils.disposeObject(this._itemCell1);
         this._itemCell1 = null;
         ObjectUtils.disposeObject(this._itemCell2);
         this._itemCell2 = null;
         ObjectUtils.disposeObject(this._itemCell3);
         this._itemCell3 = null;
         ObjectUtils.disposeObject(this._cellBg1);
         this._cellBg1 = null;
         ObjectUtils.disposeObject(this._cellBg2);
         this._cellBg2 = null;
         ObjectUtils.disposeObject(this._cellBg3);
         this._cellBg3 = null;
         ObjectUtils.disposeObject(this._itemBg);
         this._itemBg = null;
         ObjectUtils.disposeObject(this._goodItemBg1);
         this._goodItemBg1 = null;
         ObjectUtils.disposeObject(this._goodItemBg1);
         this._goodItemBg1 = null;
         ObjectUtils.disposeObject(this._goodItemBg2);
         this._goodItemBg2 = null;
         ObjectUtils.disposeObject(this._goodItemBg3);
         this._goodItemBg3 = null;
         ObjectUtils.disposeObject(this._downLoadBtn);
         this._downLoadBtn = null;
         ObjectUtils.disposeObject(this._awardName1);
         this._awardName1 = null;
         ObjectUtils.disposeObject(this._awardName2);
         this._awardName2 = null;
         ObjectUtils.disposeObject(this._awardName3);
         this._awardName3 = null;
         super.dispose();
      }
   }
}
