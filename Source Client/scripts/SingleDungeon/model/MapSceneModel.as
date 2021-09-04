package SingleDungeon.model
{
   import SingleDungeon.event.CDCollingEvent;
   import ddt.data.quest.QuestInfo;
   import flash.events.EventDispatcher;
   
   public class MapSceneModel extends EventDispatcher
   {
      
      public static const WALKSCENE:int = 2;
       
      
      public var ID:int;
      
      public var Name:String;
      
      public var Type:int;
      
      public var MapID:int;
      
      public var Path:String;
      
      public var MapX:Number;
      
      public var MapY:Number;
      
      public var MinLevel:int;
      
      public var MaxLevel:int;
      
      public var QuestID:int;
      
      public var QuestType:int;
      
      public var Other:String;
      
      public var OtherCount:int;
      
      public var MissionID:int;
      
      public var Description:String;
      
      public var SenceSelfInfo:SingleDungeonPlayerInfo;
      
      public var ClothPath:String;
      
      public var CoolMoney:String;
      
      public var RelevanceQuest:String;
      
      public var CostEnergy:int;
      
      public var questData:Vector.<QuestInfo>;
      
      private var _cdColling:int;
      
      private var _count:int;
      
      public function MapSceneModel()
      {
         this.questData = new Vector.<QuestInfo>();
         super();
      }
      
      public function get cdColling() : int
      {
         return this._cdColling;
      }
      
      public function set cdColling(param1:int) : void
      {
         this._cdColling = param1;
         dispatchEvent(new CDCollingEvent(CDCollingEvent.CD_UPDATE));
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function set count(param1:int) : void
      {
         this._count = param1;
      }
   }
}
