import sys
import os

PACKAGE_PARENT = '..\preprocess'
SCRIPT_DIR = os.path.dirname(os.path.realpath(os.path.join(os.getcwd(), os.path.expanduser(__file__))))
sys.path.append(os.path.normpath(os.path.join(SCRIPT_DIR, PACKAGE_PARENT)))

from customdataset import SegmentationDataSet
from torch.utils.data import DataLoader
from torch.utils import data

inputs = ['.\..\data\images\IM001_ID001_R0.png', 
          '.\..\data\images\IM001_ID001_R0.png']
targets = ['.\..\data\ground_truth\fgt\IM001_ID001_R0.png', 
           '.\..\data\ground_truth\fgt\IM001_ID001_R0.png']

training_dataset = SegmentationDataSet(inputs=inputs,
                                       targets=targets,
                                       transform=None)

training_dataloader = data.DataLoader(dataset=training_dataset,
                                      batch_size=2,
                                      shuffle=True)
x, y = next(iter(training_dataloader))

print(f'x = shape: {x.shape}; type: {x.dtype}')
print(f'x = min: {x.min()}; max: {x.max()}')
print(f'y = shape: {y.shape}; class: {y.unique()}; type: {y.dtype}')