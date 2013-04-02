package{
	
	import astar.AStar;
	import astar.Graph;
	import astar.GraphNode;
	
	import com.flashcake.overlay.FlashCakeSfwOverlay;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import view.GraphNodeVisual;
	import view.GraphRenderer;
	
	[SWF(width="670", height="435", frameRate="30", backgroundColor="#FFFFFF")]
	public class AStarDetailed extends Sprite{
		
		private var logic:AStar = new AStar();
		private var graph:Graph = new Graph(9,5);
		private var renderer:GraphRenderer = new GraphRenderer();
		
		private var start:GraphNode;
		private var end:GraphNode;
		
		private var hint:TextField = new TextField();
		
		public function AStarDetailed(){
			addChild(renderer);
			
			addChild(new FlashCakeSfwOverlay());// Feel free to remove this layer
			
			addHint();
			
			renderer.draw(graph);
			
			start = graph.getNodeAt(2,2);
			end = graph.getNodeAt(7,2);
			graph.getNodeAt(4,1).isWall = true;
			graph.getNodeAt(4,3).isWall = true;
			
			updatePath();
			
			addEventListener( MouseEvent.MOUSE_DOWN, onClick);
		}
		
		
		protected function onClick(event:MouseEvent):void{
			var visualNode:GraphNodeVisual = event.target as GraphNodeVisual;
			if(visualNode){
				var node:GraphNode = event.target.graphNode;
				if(node!=start && node!=end){
					if(event.ctrlKey){
						node.isWall = !node.isWall;
					}else if(!node.isWall){
						if(event.shiftKey){
							end = node;
						}else{
							start = node;
						}
					}
					updatePath();
				}
			}
		}
		
		private function updatePath():void{
			var path:Vector.<GraphNode> = logic.search(graph,start,end);
			renderer.update(graph,path,logic.openList,logic.closedList);
			renderer.showStartAndEndNodes(start,end);
		}
		
		private function addHint():void{
			addChild(hint);
			hint.width = 550;
			hint.height = 55;
			//hint.border = true;
			hint.selectable = false;
			hint.mouseEnabled = false;
			hint.multiline = true;
			hint.wordWrap = true;
			hint.x = 10;
			hint.y = stage.height - hint.height - 2;
			hint.defaultTextFormat = new TextFormat('_typewriter',14);
			hint.htmlText = 'Click <b>left mouse button</b> to set starting point.';
			hint.htmlText += 'Press <b>shift + left mouse button</b> to set end point.';
			hint.htmlText += 'Press <b>ctrl + left mouse button</b> to add or remove a wall.';
		}
		
		
	}
}