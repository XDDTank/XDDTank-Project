package consortion.view.club
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import consortion.view.selfConsortia.TakeInTurnPage;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ClubViewFrame extends Frame
   {
       
      
      private var _titleBg:Bitmap;
      
      private var _btnBg:Scale9CornerImage;
      
      private var _listTopBg:MutipleImage;
      
      private var _consortionList:ConsortionList;
      
      private var _recordList:ClubRecordList;
      
      private var _rankingTxt:FilterFrameText;
      
      private var _consortionNameTxt:FilterFrameText;
      
      private var _chairmanNameTxt:FilterFrameText;
      
      private var _menberCountTxt:FilterFrameText;
      
      private var _gradeTxt:FilterFrameText;
      
      private var _applicationBtn:SelectedCheckButton;
      
      private var _menberListVLine:MutipleImage;
      
      private var _turnPage:TakeInTurnPage;
      
      private var _pageCount:int = 9;
      
      private var _createConsortionBtn:BaseButton;
      
      public function ClubViewFrame()
      {
         super();
         this.enterClub();
         escEnable = true;
      }
      
      private function enterClub() : void
      {
         ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.clubSearchConsortions,1,8,"",Math.floor(Math.random() * 5 + 1),1);
         ConsortionModelControl.Instance.getApplyRecordList(ConsortionModelControl.Instance.applyListComplete,PlayerManager.Instance.Self.ID);
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("ddtClunView.btnBg");
         addToContent(this._btnBg);
         this._titleBg = ComponentFactory.Instance.creatBitmap("asset.consortion.title");
         addToContent(this._titleBg);
         this._listTopBg = ComponentFactory.Instance.creatComponentByStylename("memberlist.Bg");
         this._listTopBg.imageRectString = "0|742|0|330|13,0|742|0|35|13";
         var _loc1_:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.ddtconsortion.ClublistTopBgRect");
         this._listTopBg.x = _loc1_.x;
         this._listTopBg.y = _loc1_.y;
         addToContent(this._listTopBg);
         this._menberListVLine = ComponentFactory.Instance.creatComponentByStylename("consortionClub.MemberListVLine");
         addToContent(this._menberListVLine);
         this._rankingTxt = ComponentFactory.Instance.creatComponentByStylename("consortionClub.MemberListTitleText6");
         this._rankingTxt.text = LanguageMgr.GetTranslation("tanl.consortion.rankingText.text");
         this._consortionNameTxt = ComponentFactory.Instance.creatComponentByStylename("consortionClub.MemberListTitleText1");
         this._consortionNameTxt.text = LanguageMgr.GetTranslation("tank.consortionClub.MemberListTitleText1.text");
         this._chairmanNameTxt = ComponentFactory.Instance.creatComponentByStylename("consortionClub.MemberListTitleText2");
         this._chairmanNameTxt.text = LanguageMgr.GetTranslation("tank.consortionClub.MemberListTitleText2.text");
         this._menberCountTxt = ComponentFactory.Instance.creatComponentByStylename("consortionClub.MemberListTitleText3");
         this._menberCountTxt.text = LanguageMgr.GetTranslation("tank.consortionClub.MemberListTitleText3.text");
         this._gradeTxt = ComponentFactory.Instance.creatComponentByStylename("consortionClub.MemberListTitleText4");
         this._gradeTxt.text = LanguageMgr.GetTranslation("tank.consortionClub.MemberListTitleText4.text");
         this._applicationBtn = ComponentFactory.Instance.creatComponentByStylename("ddtClubView.ApplySelectedbtn");
         this._applicationBtn.text = LanguageMgr.GetTranslation("ddt.consortion.club.alreadlyApply");
         this._applicationBtn.selected = false;
         addToContent(this._rankingTxt);
         addToContent(this._consortionNameTxt);
         addToContent(this._chairmanNameTxt);
         addToContent(this._menberCountTxt);
         addToContent(this._gradeTxt);
         addToContent(this._applicationBtn);
         this._consortionList = ComponentFactory.Instance.creatComponentByStylename("club.consortionList");
         addToContent(this._consortionList);
         this._turnPage = ComponentFactory.Instance.creatCustomObject("takeInTurnPage");
         addToContent(this._turnPage);
         this._createConsortionBtn = ComponentFactory.Instance.creatComponentByStylename("club.createConsortion");
         addToContent(this._createConsortionBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__resposeHandler);
         this._applicationBtn.addEventListener(MouseEvent.CLICK,this.__applySelect);
         this._turnPage.addEventListener(TakeInTurnPage.PAGE_CHANGE,this.__pageChangeHandler);
         this._createConsortionBtn.addEventListener(MouseEvent.CLICK,this.__createConsortionHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE,this.__consrotionListComplete);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.CONSORTIONLIST_IS_CHANGE,this.__consrotionListComplete);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__resposeHandler);
         this._turnPage.removeEventListener(TakeInTurnPage.PAGE_CHANGE,this.__pageChangeHandler);
         this._createConsortionBtn.removeEventListener(MouseEvent.CLICK,this.__createConsortionHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE,this.__consrotionListComplete);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.CONSORTIONLIST_IS_CHANGE,this.__consrotionListComplete);
         this._applicationBtn.removeEventListener(MouseEvent.CLICK,this.__applySelect);
      }
      
      private function __applySelect(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this._applicationBtn.selected)
         {
            if(ConsortionModelControl.Instance.model.readyApplyList == null)
            {
               this._consortionList.setListData(ConsortionModelControl.Instance.model.readyApplyList);
               this._turnPage.sum = 1;
            }
            else
            {
               this._turnPage.sum = Math.ceil(ConsortionModelControl.Instance.model.myApplyList.length / this._pageCount);
               this._consortionList.setListData(ConsortionModelControl.Instance.model.getreadApplyconsrotionListWithPage(this._turnPage.present,this._pageCount));
            }
            this._applicationBtn.selected = true;
         }
         else
         {
            this._turnPage.sum = Math.ceil(ConsortionModelControl.Instance.model.consortionList.length / this._pageCount);
            this._consortionList.setListData(ConsortionModelControl.Instance.model.getconsrotionListWithPage(this._turnPage.present,this._pageCount));
            this._applicationBtn.selected = false;
         }
      }
      
      private function __pageChangeHandler(param1:Event) : void
      {
         if(this._applicationBtn.selected)
         {
            this._turnPage.sum = Math.ceil(ConsortionModelControl.Instance.model.myApplyList.length / this._pageCount);
            this._consortionList.setListData(ConsortionModelControl.Instance.model.getreadApplyconsrotionListWithPage(this._turnPage.present,this._pageCount));
         }
         else
         {
            this._turnPage.sum = Math.ceil(ConsortionModelControl.Instance.model.consortionList.length / this._pageCount);
            this._consortionList.setListData(ConsortionModelControl.Instance.model.getconsrotionListWithPage(this._turnPage.present,this._pageCount));
         }
      }
      
      private function __resposeHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __createConsortionHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            return MessageTipManager.getInstance().show("您已加入公会");
         }
         var _loc2_:CreateConsortionFrame = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame");
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __consrotionListComplete(param1:ConsortionEvent) : void
      {
         if(ConsortionModelControl.Instance.model.consortionList == null)
         {
            return;
         }
         this._turnPage.sum = Math.ceil(ConsortionModelControl.Instance.model.consortionList.length / this._pageCount);
         if(this._applicationBtn.selected)
         {
            this._consortionList.setListData(ConsortionModelControl.Instance.model.getreadApplyconsrotionListWithPage(this._turnPage.present,this._pageCount));
         }
         else
         {
            this._consortionList.setListData(ConsortionModelControl.Instance.model.getconsrotionListWithPage(this._turnPage.present,this._pageCount));
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._btnBg)
         {
            ObjectUtils.disposeObject(this._btnBg);
         }
         this._btnBg = null;
         if(this._titleBg)
         {
            ObjectUtils.disposeObject(this._titleBg);
         }
         this._titleBg = null;
         if(this._listTopBg)
         {
            ObjectUtils.disposeObject(this._listTopBg);
         }
         this._listTopBg = null;
         if(this._rankingTxt)
         {
            ObjectUtils.disposeObject(this._rankingTxt);
         }
         this._rankingTxt = null;
         if(this._consortionNameTxt)
         {
            ObjectUtils.disposeObject(this._consortionNameTxt);
         }
         this._consortionNameTxt = null;
         if(this._chairmanNameTxt)
         {
            ObjectUtils.disposeObject(this._chairmanNameTxt);
         }
         this._chairmanNameTxt = null;
         if(this._menberCountTxt)
         {
            ObjectUtils.disposeObject(this._menberCountTxt);
         }
         this._menberCountTxt = null;
         if(this._gradeTxt)
         {
            ObjectUtils.disposeObject(this._gradeTxt);
         }
         this._gradeTxt = null;
         if(this._applicationBtn)
         {
            ObjectUtils.disposeObject(this._applicationBtn);
         }
         this._applicationBtn = null;
         if(this._menberListVLine)
         {
            ObjectUtils.disposeObject(this._menberListVLine);
         }
         this._menberListVLine = null;
         if(this._consortionList)
         {
            ObjectUtils.disposeObject(this._consortionList);
         }
         this._consortionList = null;
         if(this._turnPage)
         {
            ObjectUtils.disposeObject(this._turnPage);
         }
         this._turnPage = null;
         if(this._createConsortionBtn)
         {
            ObjectUtils.disposeObject(this._createConsortionBtn);
         }
         this._createConsortionBtn = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
