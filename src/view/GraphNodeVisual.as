package view {
	
	
	import astar.GraphNode;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class GraphNodeVisual extends Sprite{
		
		public static const LEFT:Number = Math.PI;
		public static const RIGHT:Number = 0;
		public static const TOP:Number = -Math.PI/2;
		public static const TOP_LEFT:Number = -Math.PI*3/4;
		public static const BOTTOM_LEFT:Number = -Math.PI*5/4;
		public static const TOP_RIGHT:Number = -Math.PI/4;
		public static const BOTTOM_RIGHT:Number = -Math.PI*7/4;
		public static const BOTTOM:Number = -Math.PI*3/2;
		
		private static const SIDE:Number = 70;
		private static const GAP:Number = 2;
		
		private static const format:TextFormat = new TextFormat('_typewriter', 10);
		private var gText:TextField = new TextField();
		private var hText:TextField = new TextField();
		private var fText:TextField = new TextField();
		
		private var parameters:Sprite = new Sprite();
		private var direction:Sprite = new Sprite();
		
		public var graphNode:GraphNode = null;
		
		
		public function GraphNodeVisual(graphNode:GraphNode):void{
			this.graphNode = graphNode;
			
			buttonMode = true;
			addChild(direction);
			addChild(parameters);
			for each (var field:TextField in [gText,hText,fText]) {
				field.selectable = false;
				field.mouseEnabled = false;
				field.defaultTextFormat = format;
				field.width = 34;
				field.height = 15;
				//field.border = true;
				parameters.addChild(field);
			}
			
			direction.mouseEnabled = false;
			
			hideDetails();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			this.x = (SIDE+GAP)*graphNode.x+(stage.stageWidth-(SIDE+GAP)*9)/2;
			this.y = (SIDE+GAP)*graphNode.y+13;//+(stage.stageHeight-(SIDE+GAP)*5)/2;//vertical align middle 
		}
		
		public function hideDetails():void{
			parameters.visible = false;
			direction.visible = false;
			if(graphNode.isWall){
				redrawBackground(0x9CA4AD,0x8A8F96);
			}else{
				redrawBackground(0xFFFFFF);
			}
		}
		
		public function showDetails():void{
			parameters.visible = true;
			hText.text = 'h:'+int(graphNode.h);
			gText.text = 'g:'+int(graphNode.g);
			fText.text = 'f:'+int(graphNode.f);
			
			hText.x = GAP+1; hText.y = 0;
			gText.x = GAP+1; gText.y = SIDE-GAP-1-hText.textHeight;
			fText.x = SIDE-GAP*2-fText.textWidth; fText.y = SIDE-GAP-1-fText.textHeight;
		}
		
		public function showType(isOpen:Boolean):void{
			redrawBackground(isOpen?0xB4FFA5:0xA5E7FF);
		}
		
		public function showPathPoint():void{
			direction.visible = true;
			direction.graphics.clear();
			
			direction.graphics.beginFill(0xFF4433);
			direction.graphics.drawCircle(SIDE/2,SIDE/2,6);
		}
		
		public function showDirection(parentDirection:Number):void{
			if(!isNaN(parentDirection)){
				drawArrow(parentDirection,0x9CA4AD);
			}
		}
		
		public function showCrossMarker(isEnd:Boolean):void{
			if(!isEnd) parameters.visible = false;
			direction.visible = true;
			direction.graphics.clear();
			direction.graphics.lineStyle(isEnd?5:3,0xFF4433);
			var size:int = 10;
			direction.graphics.moveTo(SIDE/2-size,SIDE/2-size);
			direction.graphics.lineTo(SIDE/2+size,SIDE/2+size);
			direction.graphics.moveTo(SIDE/2+size,SIDE/2-size);
			direction.graphics.lineTo(SIDE/2-size,SIDE/2+size);
		}
		
		private function redrawBackground(color:int,hatching:int = int.MAX_VALUE):void{
			graphics.clear();
			graphics.lineStyle(1,0x8A8F96);
			graphics.beginFill(color, 0.3);
			graphics.drawRect(0,0,SIDE,SIDE);
			graphics.endFill();
			
			if(hatching!=int.MAX_VALUE){
				graphics.lineStyle(1,hatching);
				for (var i:int = 0; i <= SIDE; i+=10) {
					graphics.moveTo(i,0);
					graphics.lineTo(0,i);
					graphics.moveTo(SIDE,SIDE-i);
					graphics.lineTo(SIDE-i,SIDE);
				}
			}
		}
		
		public function drawArrow(angle:Number,color:uint):void{
			if(!isNaN(angle)){
				direction.visible = true;
				direction.graphics.clear();
				
				direction.graphics.beginFill(color);
				direction.graphics.drawCircle(SIDE/2,SIDE/2,4);
				direction.graphics.endFill();
				
				direction.graphics.lineStyle(3,color);
				direction.graphics.moveTo(SIDE/2+Math.cos(angle)*25,SIDE/2+Math.sin(angle)*25);
				direction.graphics.lineTo(SIDE/2+Math.cos(angle)*5,SIDE/2+Math.sin(angle)*5);
				
				direction.graphics.lineTo(
					SIDE/2+Math.cos(angle)*5+Math.cos(angle-0.4)*10,
					SIDE/2+Math.sin(angle)*5+Math.sin(angle-0.4)*10);
				direction.graphics.moveTo(SIDE/2+Math.cos(angle)*5,SIDE/2+Math.sin(angle)*5);
				direction.graphics.lineTo(
					SIDE/2+Math.cos(angle)*5+Math.cos(angle+0.4)*10,
					SIDE/2+Math.sin(angle)*5+Math.sin(angle+0.4)*10);
			}
		}
	}
	
	
}